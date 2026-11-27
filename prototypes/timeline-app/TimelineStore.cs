using System.Data;
using Npgsql;

namespace ReorganisationTimeline;

public sealed record EstablishmentRef(int Urn, string Name);

public sealed record ItemParticipant(int Urn, string Name, string Outcome, IReadOnlyList<string> Effects, string Side, bool IsEntered);

public sealed record ItemPair(string Kind, int FromUrn, int ToUrn);

public sealed record TimelineItem(
    string Key,
    string Kind,
    string? Pattern,
    string? Cause,
    string Title,
    DateOnly? Date,
    string? DateSource,
    bool Direct,
    EstablishmentRef? Via,
    IReadOnlyList<ItemParticipant> Participants,
    IReadOnlyList<ItemPair> Pairs,
    string? Note);

public sealed record TimelineResponse(
    int Urn,
    bool Found,
    EstablishmentRef? Establishment,
    bool Connected,
    bool Truncated,
    IReadOnlyList<TimelineItem> Items);

public sealed class MissingSchemaException(string message) : Exception(message);

/// <summary>
/// Reads reorganisations, and successions or provision transfers recorded without one,
/// for an establishment. When asked, it follows them to connected establishments.
/// Every request reads inside one read-only, repeatable-read transaction.
/// </summary>
public sealed class TimelineStore(NpgsqlDataSource dataSource)
{
    private const int MaxSteps = 20;
    private const int MaxItems = 300;

    private sealed record Found(char Kind, Guid Id, Guid Matched);

    private sealed record Person(Guid Id, int Urn, string Name);

    public async Task<TimelineResponse> LoadAsync(int urn, bool connected, CancellationToken ct)
    {
        await using var connection = await dataSource.OpenConnectionAsync(ct);
        await using var transaction = await connection.BeginTransactionAsync(IsolationLevel.RepeatableRead, ct);
        await ExecuteAsync(connection, "SET TRANSACTION READ ONLY; SET LOCAL search_path = establishment;", ct);

        await using (var check = new NpgsqlCommand(
            "SELECT to_regclass('establishment.establishment_reorganisation') IS NOT NULL", connection))
        {
            if (!(bool)(await check.ExecuteScalarAsync(ct))!)
            {
                throw new MissingSchemaException(
                    "This database has no reorganisation tables. Rebuild it with the current establishment schema.");
            }
        }

        var root = await ReadEstablishmentAsync(connection, urn, ct);
        if (root is null)
        {
            return new TimelineResponse(urn, false, null, connected, false, []);
        }

        // Breadth-first search over shared reorganisations and standalone pairs.
        var via = new Dictionary<(char Kind, Guid Id), Guid?>();
        var reached = new HashSet<Guid> { root.Id };
        var frontier = new List<Guid> { root.Id };
        var truncated = false;
        for (var step = 0; frontier.Count > 0; step++)
        {
            var found = await FindItemsAsync(connection, frontier.ToArray(), ct);
            var added = new List<Found>();
            foreach (var item in found)
            {
                if (via.TryAdd((item.Kind, item.Id), item.Matched == root.Id ? null : item.Matched))
                {
                    added.Add(item);
                }
            }
            if (!connected || added.Count == 0)
            {
                break;
            }
            var endpoints = await FindEndpointsAsync(connection,
                added.Where(a => a.Kind == 'r').Select(a => a.Id).ToArray(),
                added.Where(a => a.Kind == 's').Select(a => a.Id).ToArray(),
                added.Where(a => a.Kind == 't').Select(a => a.Id).ToArray(), ct);
            frontier = endpoints.Where(reached.Add).ToList();
            if (frontier.Count > 0 && (step + 1 >= MaxSteps || via.Count >= MaxItems))
            {
                truncated = true;
                break;
            }
        }

        var reorgIds = via.Keys.Where(k => k.Kind == 'r').Select(k => k.Id).ToArray();
        var successionIds = via.Keys.Where(k => k.Kind == 's').Select(k => k.Id).ToArray();
        var transferIds = via.Keys.Where(k => k.Kind == 't').Select(k => k.Id).ToArray();

        var reorganisations = await ReadReorganisationsAsync(connection, reorgIds, ct);
        var participants = await ReadParticipantsAsync(connection, reorgIds, ct);
        var effects = await ReadEffectsAsync(connection, participants.Select(p => p.ParticipantId).ToArray(), ct);
        var successions = await ReadPairsAsync(connection, SuccessionSql, reorgIds, successionIds, ct);
        var transfers = await ReadPairsAsync(connection, TransferSql, reorgIds, transferIds, ct);
        await transaction.CommitAsync(ct);

        var people = new Dictionary<Guid, Person> { [root.Id] = root };
        foreach (var p in participants) people[p.EstablishmentId] = new Person(p.EstablishmentId, p.Urn, p.Name);
        foreach (var p in successions.Concat(transfers))
        {
            people[p.From.Id] = p.From;
            people[p.To.Id] = p.To;
        }
        EstablishmentRef? ViaRef(Guid? id) =>
            id is Guid g && people.TryGetValue(g, out var person) ? new EstablishmentRef(person.Urn, person.Name) : null;

        var items = new List<TimelineItem>();
        foreach (var r in reorganisations)
        {
            var members = participants.Where(p => p.ReorganisationId == r.Id).ToList();
            var pairs = successions.Where(s => s.ReorganisationId == r.Id).Select(s => new ItemPair("succession", s.From.Urn, s.To.Urn))
                .Concat(transfers.Where(t => t.ReorganisationId == r.Id).Select(t => new ItemPair("transfer", t.From.Urn, t.To.Urn)))
                .ToList();
            var origins = pairs.Select(p => p.FromUrn).ToHashSet();
            var receivers = pairs.Select(p => p.ToUrn).ToHashSet();

            var list = members.Select(m => new ItemParticipant(
                m.Urn, m.Name, m.Outcome, effects.GetValueOrDefault(m.ParticipantId) ?? [],
                IsFrom(m.Urn, m.Outcome, origins, receivers, pairs.Count) ? "from" : "to",
                m.Urn == urn)).ToList();

            var (date, source) = r.EffectiveDate is DateOnly d
                ? (d, "reviewed")
                : DeriveDate(members.Where(m => m.Outcome == "Opened").Select(m => m.OpenDate),
                             members.Where(m => m.Outcome == "Closed").Select(m => m.CloseDate));

            var key = (Kind: 'r', r.Id);
            items.Add(new TimelineItem("r:" + r.Id, "reorganisation", r.Pattern, r.Cause,
                Titles.ForReorganisation(r.Pattern, r.Cause, list), date, source,
                via[key] is null, ViaRef(via[key]), list, pairs, r.Description));
        }

        foreach (var (kind, letter, rows) in new[] { ("succession", 's', successions), ("transfer", 't', transfers) })
        {
            foreach (var p in rows.Where(p => p.ReorganisationId is null && via.ContainsKey((letter, p.Id))))
            {
                var fromOutcome = kind == "succession" ? "Predecessor" : "Origin";
                var toOutcome = kind == "succession" ? "Successor" : "Recipient";
                var list = new List<ItemParticipant>
                {
                    new(p.From.Urn, p.From.Name, fromOutcome, [], "from", p.From.Urn == urn),
                    new(p.To.Urn, p.To.Name, toOutcome, [], "to", p.To.Urn == urn),
                };
                var (date, source) = p.EffectiveDate is DateOnly d
                    ? (d, "reviewed")
                    : DeriveDate([p.ToOpenDate], [p.FromCloseDate]);
                var v = via[(letter, p.Id)];
                items.Add(new TimelineItem(letter + ":" + p.Id, kind, null, null,
                    Titles.ForPair(kind, p.From.Name, p.To.Name), date, source,
                    v is null, ViaRef(v), list, [new ItemPair(kind, p.From.Urn, p.To.Urn)],
                    "Recorded as a pair, with no reorganisation."));
            }
        }

        items = items
            .OrderBy(i => i.Date is null)
            .ThenByDescending(i => i.Date)
            .ThenBy(i => i.Title, StringComparer.Ordinal)
            .ToList();
        return new TimelineResponse(urn, true, new EstablishmentRef(root.Urn, root.Name), connected, truncated, items);
    }

    // An establishment is on the "before" side if provision leaves it and nothing arrives.
    // With no pairs recorded, closed establishments go on the "before" side.
    private static bool IsFrom(int urn, string outcome, HashSet<int> origins, HashSet<int> receivers, int pairCount) =>
        pairCount == 0 ? outcome == "Closed" : origins.Contains(urn) && !receivers.Contains(urn);

    // Use the earliest opening of a new establishment, else the latest closure.
    private static (DateOnly?, string?) DeriveDate(IEnumerable<DateOnly?> openings, IEnumerable<DateOnly?> closures)
    {
        var opened = openings.Where(d => d is not null).Min();
        if (opened is not null) return (opened, "lifecycle");
        var closed = closures.Where(d => d is not null).Max();
        return closed is not null ? (closed, "lifecycle") : (null, null);
    }

    private static async Task ExecuteAsync(NpgsqlConnection connection, string sql, CancellationToken ct)
    {
        await using var command = new NpgsqlCommand(sql, connection);
        await command.ExecuteNonQueryAsync(ct);
    }

    private static DateOnly? DateOrNull(NpgsqlDataReader reader, int ordinal) =>
        reader.IsDBNull(ordinal) ? null : reader.GetFieldValue<DateOnly>(ordinal);

    private static string? StringOrNull(NpgsqlDataReader reader, int ordinal) =>
        reader.IsDBNull(ordinal) ? null : reader.GetString(ordinal);

    private static async Task<Person?> ReadEstablishmentAsync(NpgsqlConnection connection, int urn, CancellationToken ct)
    {
        await using var command = new NpgsqlCommand(
            "SELECT establishment_id, urn, name FROM establishment WHERE urn = @urn", connection);
        command.Parameters.AddWithValue("urn", urn);
        await using var reader = await command.ExecuteReaderAsync(ct);
        return await reader.ReadAsync(ct) ? new Person(reader.GetGuid(0), reader.GetInt32(1), reader.GetString(2)) : null;
    }

    private static async Task<List<Found>> FindItemsAsync(NpgsqlConnection connection, Guid[] ids, CancellationToken ct)
    {
        const string sql = """
            SELECT 'r', establishment_reorganisation_id, establishment_id
            FROM reorganisation_participant
            WHERE establishment_id = ANY(@ids)
            UNION ALL
            SELECT 's', establishment_succession_id,
                   CASE WHEN predecessor_establishment_id = ANY(@ids) THEN predecessor_establishment_id ELSE successor_establishment_id END
            FROM establishment_succession
            WHERE establishment_reorganisation_id IS NULL
              AND (predecessor_establishment_id = ANY(@ids) OR successor_establishment_id = ANY(@ids))
            UNION ALL
            SELECT 't', establishment_provision_transfer_id,
                   CASE WHEN origin_establishment_id = ANY(@ids) THEN origin_establishment_id ELSE recipient_establishment_id END
            FROM establishment_provision_transfer
            WHERE establishment_reorganisation_id IS NULL
              AND (origin_establishment_id = ANY(@ids) OR recipient_establishment_id = ANY(@ids))
            """;
        await using var command = new NpgsqlCommand(sql, connection);
        command.Parameters.AddWithValue("ids", ids);
        await using var reader = await command.ExecuteReaderAsync(ct);
        var result = new List<Found>();
        while (await reader.ReadAsync(ct))
        {
            result.Add(new Found(reader.GetString(0)[0], reader.GetGuid(1), reader.GetGuid(2)));
        }
        return result;
    }

    private static async Task<List<Guid>> FindEndpointsAsync(NpgsqlConnection connection,
        Guid[] reorgIds, Guid[] successionIds, Guid[] transferIds, CancellationToken ct)
    {
        const string sql = """
            SELECT establishment_id FROM reorganisation_participant WHERE establishment_reorganisation_id = ANY(@r)
            UNION SELECT predecessor_establishment_id FROM establishment_succession WHERE establishment_succession_id = ANY(@s)
            UNION SELECT successor_establishment_id FROM establishment_succession WHERE establishment_succession_id = ANY(@s)
            UNION SELECT origin_establishment_id FROM establishment_provision_transfer WHERE establishment_provision_transfer_id = ANY(@t)
            UNION SELECT recipient_establishment_id FROM establishment_provision_transfer WHERE establishment_provision_transfer_id = ANY(@t)
            """;
        await using var command = new NpgsqlCommand(sql, connection);
        command.Parameters.AddWithValue("r", reorgIds);
        command.Parameters.AddWithValue("s", successionIds);
        command.Parameters.AddWithValue("t", transferIds);
        await using var reader = await command.ExecuteReaderAsync(ct);
        var result = new List<Guid>();
        while (await reader.ReadAsync(ct)) result.Add(reader.GetGuid(0));
        return result;
    }

    private sealed record ReorganisationRow(Guid Id, string Pattern, string? Cause, DateOnly? EffectiveDate, string? Description);

    private static async Task<List<ReorganisationRow>> ReadReorganisationsAsync(NpgsqlConnection connection, Guid[] ids, CancellationToken ct)
    {
        const string sql = """
            SELECT r.establishment_reorganisation_id, p.name, c.name, r.effective_date, r.description
            FROM establishment_reorganisation r
            JOIN reorganisation_pattern p USING (reorganisation_pattern_id)
            LEFT JOIN reorganisation_cause c USING (reorganisation_cause_id)
            WHERE r.establishment_reorganisation_id = ANY(@ids)
            """;
        await using var command = new NpgsqlCommand(sql, connection);
        command.Parameters.AddWithValue("ids", ids);
        await using var reader = await command.ExecuteReaderAsync(ct);
        var result = new List<ReorganisationRow>();
        while (await reader.ReadAsync(ct))
        {
            result.Add(new ReorganisationRow(reader.GetGuid(0), reader.GetString(1), StringOrNull(reader, 2),
                DateOrNull(reader, 3), StringOrNull(reader, 4)));
        }
        return result;
    }

    private sealed record ParticipantRow(Guid ReorganisationId, Guid ParticipantId, Guid EstablishmentId, int Urn,
        string Name, string Outcome, DateOnly? OpenDate, DateOnly? CloseDate);

    private static async Task<List<ParticipantRow>> ReadParticipantsAsync(NpgsqlConnection connection, Guid[] ids, CancellationToken ct)
    {
        const string sql = """
            SELECT rp.establishment_reorganisation_id, rp.reorganisation_participant_id, e.establishment_id, e.urn, e.name,
                   o.name, l.open_date, l.close_date
            FROM reorganisation_participant rp
            JOIN establishment e ON e.establishment_id = rp.establishment_id
            JOIN reorganisation_outcome o ON o.reorganisation_outcome_id = rp.reorganisation_outcome_id
            LEFT JOIN establishment_lifecycle l ON l.establishment_id = e.establishment_id
            WHERE rp.establishment_reorganisation_id = ANY(@ids)
            ORDER BY e.urn
            """;
        await using var command = new NpgsqlCommand(sql, connection);
        command.Parameters.AddWithValue("ids", ids);
        await using var reader = await command.ExecuteReaderAsync(ct);
        var result = new List<ParticipantRow>();
        while (await reader.ReadAsync(ct))
        {
            result.Add(new ParticipantRow(reader.GetGuid(0), reader.GetGuid(1), reader.GetGuid(2), reader.GetInt32(3),
                reader.GetString(4), reader.GetString(5), DateOrNull(reader, 6), DateOrNull(reader, 7)));
        }
        return result;
    }

    private static async Task<Dictionary<Guid, List<string>>> ReadEffectsAsync(NpgsqlConnection connection, Guid[] ids, CancellationToken ct)
    {
        const string sql = """
            SELECT x.reorganisation_participant_id, t.name
            FROM reorganisation_effect x
            JOIN reorganisation_effect_type t USING (reorganisation_effect_type_id)
            WHERE x.reorganisation_participant_id = ANY(@ids)
            ORDER BY t.name
            """;
        await using var command = new NpgsqlCommand(sql, connection);
        command.Parameters.AddWithValue("ids", ids);
        await using var reader = await command.ExecuteReaderAsync(ct);
        var result = new Dictionary<Guid, List<string>>();
        while (await reader.ReadAsync(ct))
        {
            var id = reader.GetGuid(0);
            if (!result.TryGetValue(id, out var list)) result[id] = list = [];
            list.Add(reader.GetString(1));
        }
        return result;
    }

    private sealed record PairRow(Guid Id, Guid? ReorganisationId, DateOnly? EffectiveDate,
        Person From, DateOnly? FromCloseDate, Person To, DateOnly? ToOpenDate);

    private const string SuccessionSql = """
        SELECT s.establishment_succession_id, s.establishment_reorganisation_id, s.effective_date,
               a.establishment_id, a.urn, a.name, la.close_date,
               b.establishment_id, b.urn, b.name, lb.open_date
        FROM establishment_succession s
        JOIN establishment a ON a.establishment_id = s.predecessor_establishment_id
        JOIN establishment b ON b.establishment_id = s.successor_establishment_id
        LEFT JOIN establishment_lifecycle la ON la.establishment_id = a.establishment_id
        LEFT JOIN establishment_lifecycle lb ON lb.establishment_id = b.establishment_id
        WHERE s.establishment_reorganisation_id = ANY(@r) OR s.establishment_succession_id = ANY(@p)
        ORDER BY a.urn, b.urn
        """;

    private const string TransferSql = """
        SELECT t.establishment_provision_transfer_id, t.establishment_reorganisation_id, t.effective_date,
               a.establishment_id, a.urn, a.name, la.close_date,
               b.establishment_id, b.urn, b.name, lb.open_date
        FROM establishment_provision_transfer t
        JOIN establishment a ON a.establishment_id = t.origin_establishment_id
        JOIN establishment b ON b.establishment_id = t.recipient_establishment_id
        LEFT JOIN establishment_lifecycle la ON la.establishment_id = a.establishment_id
        LEFT JOIN establishment_lifecycle lb ON lb.establishment_id = b.establishment_id
        WHERE t.establishment_reorganisation_id = ANY(@r) OR t.establishment_provision_transfer_id = ANY(@p)
        ORDER BY a.urn, b.urn
        """;

    private static async Task<List<PairRow>> ReadPairsAsync(NpgsqlConnection connection, string sql,
        Guid[] reorgIds, Guid[] pairIds, CancellationToken ct)
    {
        await using var command = new NpgsqlCommand(sql, connection);
        command.Parameters.AddWithValue("r", reorgIds);
        command.Parameters.AddWithValue("p", pairIds);
        await using var reader = await command.ExecuteReaderAsync(ct);
        var result = new List<PairRow>();
        while (await reader.ReadAsync(ct))
        {
            result.Add(new PairRow(reader.GetGuid(0), reader.IsDBNull(1) ? null : reader.GetGuid(1), DateOrNull(reader, 2),
                new Person(reader.GetGuid(3), reader.GetInt32(4), reader.GetString(5)), DateOrNull(reader, 6),
                new Person(reader.GetGuid(7), reader.GetInt32(8), reader.GetString(9)), DateOrNull(reader, 10)));
        }
        return result;
    }
}
