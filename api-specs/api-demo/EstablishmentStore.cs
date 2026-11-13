using System.Data;
using System.Globalization;
using System.Text.Json.Nodes;
using Npgsql;
using NpgsqlTypes;

namespace ApiDemo;

public sealed record LoadResult(
    DateTimeOffset? RefreshedAt,
    IReadOnlyList<JsonObject> Establishments,
    IReadOnlyList<int> IncompleteUrns,
    bool HasNextPage = false);

/// <summary>
/// Reads the establishment schema and builds API payloads.
/// Every request reads inside one read-only, repeatable-read transaction,
/// so a response always comes from one consistent view of the data.
/// </summary>
public sealed class EstablishmentStore(NpgsqlDataSource dataSource)
{
    // Responsibility type ids in establishment.establishment_responsibility_type.
    private const int RunByAcademyTrust = 1;
    private const int SupportedByFoundationTrust = 2;
    private const int SponsoredBy = 3;
    private const int MaintainedByLocalAuthority = 5;

    /// <summary>The last refresh time seen, used for headers on every response.</summary>
    public DateTimeOffset? LastKnownRefresh { get; private set; }

    public async Task<LoadResult> LoadAsync(int? urn, int? statusCode, CancellationToken ct,
        int? pageSize = null, long offset = 0)
    {
        await using var connection = await dataSource.OpenConnectionAsync(ct);
        await using var transaction = await connection.BeginTransactionAsync(IsolationLevel.RepeatableRead, ct);
        await ExecuteAsync(connection, "SET TRANSACTION READ ONLY; SET LOCAL search_path = establishment;", ct);

        var refreshedAt = await ReadRefreshedAtAsync(connection, ct);
        LastKnownRefresh = refreshedAt;
        if (refreshedAt is null)
        {
            return new LoadResult(null, [], []);
        }

        var cores = await ReadCoresAsync(connection, urn, statusCode, ct, pageSize, offset);
        var hasNextPage = pageSize is int size && cores.Count > size;
        if (hasNextPage)
        {
            cores.RemoveAt(cores.Count - 1);
        }
        var ids = cores.Select(c => c.Id).ToArray();
        var sites = await ReadSitesAsync(connection, ids, ct);
        var sen = await ReadSenAsync(connection, ids, ct);
        var responsibilities = await ReadResponsibilitiesAsync(connection, ids, ct);
        var federations = await ReadFederationsAsync(connection, ids, ct);
        await transaction.CommitAsync(ct);

        var establishments = new List<JsonObject>();
        var incomplete = new List<int>();
        foreach (var core in cores)
        {
            var payload = Build(core,
                sites[core.Id], sen[core.Id], responsibilities[core.Id], federations[core.Id]);
            if (payload is null)
            {
                incomplete.Add(core.Urn);
            }
            else
            {
                establishments.Add(payload);
            }
        }
        return new LoadResult(refreshedAt, establishments, incomplete, hasNextPage);
    }

    // ---------------------------------------------------------------- queries

    private const string RefreshSql = """
        SELECT max(coalesce(completed_at, started_at))
        FROM migration.migration_run
        WHERE status = 'completed'
        """;

    private const string CoreSql = """
        WITH page_owners AS (
            SELECT e.establishment_id, e.urn
            FROM establishment e
            WHERE ($1::int IS NULL OR e.urn = $1)
              AND EXISTS (
                  SELECT 1 FROM establishment_lifecycle l
                  JOIN establishment_status st USING (establishment_status_id)
                  WHERE l.establishment_id = e.establishment_id
                    AND st.code IN (1, 2)
                    AND ($2::int IS NULL OR st.code = $2)
              )
            ORDER BY e.urn
            LIMIT $3 OFFSET $4
        )
        SELECT e.establishment_id, e.urn, e.ukprn::text AS ukprn, e.establishment_number,
               e.name, e.ofsted_link,
               et.code AS type_code, et.name AS type_name,
               cat.code::text AS category_code, cat.name AS category_name,
               ep.code::text AS phase_code, ep.name AS phase_name,
               st.code::text AS status_code, st.name AS status_name,
               l.open_date, l.close_date, l.last_changed_date,
               reo.code AS opened_code, reo.name AS opened_name,
               rec.code AS closed_code, rec.name AS closed_name,
               c.website, c.telephone_number,
               lpad(la.code::text, 3, '0') AS la_code, la.name AS la_name, gss.code AS gss_code,
               gor.code AS gor_code, gor.name AS gor_name,
               da.code AS district_code, da.name AS district_name,
               aw.code AS ward_code, aw.name AS ward_name,
               pc.code AS constituency_code, pc.name AS constituency_name,
               ur.code AS urban_rural_code, ur.name AS urban_rural_name,
               ls.code AS lsoa_code, ls.name AS lsoa_name,
               ms.code AS msoa_code, ms.name AS msoa_name,
               sar.lower_statutory_age, sar.upper_statutory_age,
               ge.code::text AS gender_code, ge.name AS gender_name,
               ap.code::text AS admissions_code, ap.name AS admissions_name,
               bp.code::text AS boarding_code, bp.name AS boarding_name,
               np.code::text AS nursery_code, np.name AS nursery_name,
               sf.code::text AS sixth_form_code, sf.name AS sixth_form_name,
               p.has_special_classes,
               s41.code AS s41_code, s41.name AS s41_name,
               m.school_capacity, m.pupil_count, m.free_school_meal_measure, m.census_date,
               rc.code AS religious_character_code, rc.name AS religious_character_name,
               re.code AS religious_ethos_code, re.name AS religious_ethos_name,
               d.code AS diocese_code, d.name AS diocese_name,
               spt.name AS resourced_provision_type,
               rp.pupil_count AS rp_pupil_count, rp.capacity AS rp_capacity,
               su.pupil_count AS su_pupil_count, su.capacity AS su_capacity
        FROM establishment e
        JOIN page_owners owner ON owner.establishment_id = e.establishment_id
        JOIN establishment_lifecycle l ON l.establishment_id = e.establishment_id
        JOIN establishment_status st ON st.establishment_status_id = l.establishment_status_id
        LEFT JOIN establishment_type et ON et.establishment_type_id = e.establishment_type_id
        LEFT JOIN establishment_type_category cat
               ON cat.establishment_type_category_id = et.establishment_type_category_id
        LEFT JOIN education_phase ep ON ep.education_phase_id = e.education_phase_id
        LEFT JOIN reason_establishment_opened reo
               ON reo.reason_establishment_opened_id = l.reason_establishment_opened_id
        LEFT JOIN reason_establishment_closed rec
               ON rec.reason_establishment_closed_id = l.reason_establishment_closed_id
        LEFT JOIN establishment_contact c ON c.establishment_id = e.establishment_id
        LEFT JOIN establishment_geography g ON g.establishment_id = e.establishment_id
        LEFT JOIN local_authority_area la ON la.local_authority_area_id = g.local_authority_area_id
        LEFT JOIN gss_local_authority_code gss ON gss.id = la.gss_local_authority_code_id
        LEFT JOIN government_office_region gor
               ON gor.government_office_region_id = g.government_office_region_id
        LEFT JOIN district_administrative da ON da.id = g.district_administrative_id
        LEFT JOIN administrative_ward aw ON aw.id = g.administrative_ward_id
        LEFT JOIN parliamentary_constituency pc ON pc.id = g.parliamentary_constituency_id
        LEFT JOIN urban_rural ur ON ur.id = g.urban_rural_id
        LEFT JOIN lsoa ls ON ls.id = g.lsoa_id
        LEFT JOIN msoa ms ON ms.id = g.msoa_id
        LEFT JOIN education_admissions_and_provision p ON p.establishment_id = e.establishment_id
        LEFT JOIN statutory_age_range sar
               ON sar.education_admissions_and_provision_id = p.education_admissions_and_provision_id
        LEFT JOIN gender_of_entry_type ge ON ge.gender_of_entry_type_id = p.gender_of_entry_type_id
        LEFT JOIN admissions_policy ap ON ap.admissions_policy_id = p.admissions_policy_id
        LEFT JOIN boarding_provision bp ON bp.boarding_provision_id = p.boarding_provision_id
        LEFT JOIN nursery_provision np ON np.nursery_provision_id = p.nursery_provision_id
        LEFT JOIN sixth_form_provision sf ON sf.sixth_form_provision_id = p.sixth_form_provision_id
        LEFT JOIN section_41_approval_status s41
               ON s41.section_41_approval_status_id = e.section_41_approval_status_id
        LEFT JOIN capacity_and_pupil_measures m ON m.establishment_id = e.establishment_id
        LEFT JOIN religious_character rc ON rc.religious_character_id = e.religious_character_id
        LEFT JOIN religious_ethos re ON re.religious_ethos_id = e.religious_ethos_id
        LEFT JOIN diocese d ON d.diocese_id = e.diocese_id
        LEFT JOIN specialist_provision sp ON sp.establishment_id = e.establishment_id
        LEFT JOIN specialist_provision_type spt
               ON spt.specialist_provision_type_id = sp.specialist_provision_type_id
        LEFT JOIN resourced_provision rp ON rp.specialist_provision_id = sp.specialist_provision_id
        LEFT JOIN sen_unit_provision su ON su.specialist_provision_id = sp.specialist_provision_id
        WHERE st.code IN (1, 2)
          AND ($1::int IS NULL OR e.urn = $1)
          AND ($2::int IS NULL OR st.code = $2)
        ORDER BY e.urn
        """;

    private const string SiteSql = """
        SELECT es.establishment_id, s.site_id, es.is_main_site, s.site_name, s.uprn::text AS uprn,
               a.address_line_1, a.address_line_2, a.address_line_3, a.town, a.county, a.postcode
        FROM establishment_to_site es
        JOIN site s ON s.site_id = es.site_id
        LEFT JOIN address a ON a.address_id = s.address_id
        WHERE es.establishment_id = ANY($1)
        ORDER BY es.establishment_id, es.is_main_site DESC, s.site_id
        """;

    private const string SenSql = """
        SELECT es.establishment_id, s.name
        FROM establishment_sen es
        JOIN sen s ON s.sen_id = es.sen_id
        WHERE es.establishment_id = ANY($1)
        """;

    // Group identifiers belong to the party role (academy trust, foundation
    // trust or sponsor) that matches the responsibility. When a party has
    // several roles of that type, we prefer the one whose period matches.
    private const string ResponsibilitySql = """
        SELECT r.establishment_id, r.responsibility_type_id, r.is_current,
               r.start_date, r.end_date, r.person_id,
               le.name AS party_name, att.name AS academy_trust_type,
               (SELECT oi.value
                  FROM organisation_identifier oi
                  JOIN organisation_identifier_type oit
                    ON oit.organisation_identifier_type_id = oi.organisation_identifier_type_id
                 WHERE oi.legal_entity_id = r.legal_entity_id
                   AND oit.name = 'Companies House number'
                   AND oi.is_current
                 LIMIT 1) AS companies_house_number,
               ids.group_uid, ids.group_id, lac.la_code
        FROM establishment_responsibility r
        LEFT JOIN legal_entity le ON le.legal_entity_id = r.legal_entity_id
        LEFT JOIN academy_trust_type att ON att.academy_trust_type_id = r.academy_trust_type_id
        LEFT JOIN LATERAL (
            SELECT pr.establishment_party_role_id
            FROM establishment_party_role pr
            JOIN establishment_party_role_type prt
              ON prt.establishment_party_role_type_id = pr.establishment_party_role_type_id
            WHERE prt.name = CASE r.responsibility_type_id
                                 WHEN 1 THEN 'Academy trust'
                                 WHEN 2 THEN 'Foundation trust'
                                 WHEN 3 THEN 'School sponsor'
                             END
              AND (pr.legal_entity_id = r.legal_entity_id OR pr.person_id = r.person_id)
            ORDER BY (pr.start_date IS NOT DISTINCT FROM r.start_date) DESC,
                     (coalesce(pr.start_date, '-infinity') <= coalesce(r.start_date, 'infinity')
                      AND coalesce(pr.end_date, 'infinity') > coalesce(r.start_date, '-infinity')) DESC,
                     pr.start_date DESC NULLS LAST
            LIMIT 1
        ) role ON true
        LEFT JOIN LATERAL (
            SELECT max(gi.value) FILTER (WHERE git.name = 'Group UID') AS group_uid,
                   max(gi.value) FILTER (WHERE git.name = 'Group ID') AS group_id
            FROM group_identifier gi
            JOIN group_identifier_type git ON git.group_identifier_type_id = gi.group_identifier_type_id
            WHERE gi.establishment_party_role_id = role.establishment_party_role_id
              AND gi.is_current
        ) ids ON true
        LEFT JOIN LATERAL (
            -- The council's LA code for the period, only when it is unambiguous.
            SELECT CASE WHEN count(DISTINCT la.code) = 1
                        THEN lpad(min(la.code)::text, 3, '0') END AS la_code
            FROM local_authority_area_council_period cp
            JOIN local_authority_area la ON la.local_authority_area_id = cp.local_authority_area_id
            WHERE r.responsibility_type_id = 5
              AND cp.legal_entity_id = r.legal_entity_id
              AND coalesce(cp.start_date, '-infinity') < coalesce(r.end_date, 'infinity')
              AND coalesce(cp.end_date, 'infinity') > coalesce(r.start_date, '-infinity')
        ) lac ON true
        WHERE r.establishment_id = ANY($1)
          AND r.responsibility_type_id IN (1, 2, 3, 5)
        """;

    // Membership has no explicit current flag, so a membership is current
    // when it has not ended and the federation has not closed.
    private const string FederationSql = """
        SELECT m.establishment_id, g.name, m.joined_date, m.left_date,
               (m.left_date IS NULL OR m.left_date > current_date)
                 AND (g.close_date IS NULL OR g.close_date > current_date) AS is_current,
               max(gi.value) FILTER (WHERE git.name = 'Group UID') AS group_uid,
               max(gi.value) FILTER (WHERE git.name = 'Group ID') AS group_id
        FROM organisation_group_member m
        JOIN organisation_group g ON g.organisation_group_id = m.organisation_group_id
        JOIN organisation_group_type gt ON gt.organisation_group_type_id = g.organisation_group_type_id
        LEFT JOIN group_identifier gi ON gi.organisation_group_id = g.organisation_group_id AND gi.is_current
        LEFT JOIN group_identifier_type git ON git.group_identifier_type_id = gi.group_identifier_type_id
        WHERE gt.name = 'Federation'
          AND m.establishment_id = ANY($1)
        GROUP BY m.organisation_group_member_id, m.establishment_id, g.name,
                 m.joined_date, m.left_date, g.close_date
        """;

    private static async Task ExecuteAsync(NpgsqlConnection connection, string sql, CancellationToken ct)
    {
        await using var command = new NpgsqlCommand(sql, connection);
        await command.ExecuteNonQueryAsync(ct);
    }

    private static async Task<DateTimeOffset?> ReadRefreshedAtAsync(NpgsqlConnection connection, CancellationToken ct)
    {
        await using var command = new NpgsqlCommand(RefreshSql, connection);
        var value = await command.ExecuteScalarAsync(ct);
        return value is DateTime utc ? new DateTimeOffset(DateTime.SpecifyKind(utc, DateTimeKind.Utc)) : null;
    }

    private static async Task<List<Core>> ReadCoresAsync(
        NpgsqlConnection connection, int? urn, int? statusCode, CancellationToken ct,
        int? pageSize, long offset)
    {
        await using var command = new NpgsqlCommand(CoreSql, connection);
        command.Parameters.Add(new NpgsqlParameter { NpgsqlDbType = NpgsqlDbType.Integer, Value = (object?)urn ?? DBNull.Value });
        command.Parameters.Add(new NpgsqlParameter { NpgsqlDbType = NpgsqlDbType.Integer, Value = (object?)statusCode ?? DBNull.Value });
        command.Parameters.Add(new NpgsqlParameter { NpgsqlDbType = NpgsqlDbType.Integer, Value = pageSize is int size ? size + 1 : DBNull.Value });
        command.Parameters.Add(new NpgsqlParameter { NpgsqlDbType = NpgsqlDbType.Bigint, Value = offset });
        await using var reader = await command.ExecuteReaderAsync(ct);
        var row = new Row(reader);
        var cores = new List<Core>();
        var seen = new HashSet<int>();
        while (await reader.ReadAsync(ct))
        {
            var core = new Core(row);
            // One item per URN, even if a one-to-one table holds a stray duplicate.
            if (seen.Add(core.Urn))
            {
                cores.Add(core);
            }
        }
        return cores;
    }

    private static Task<ILookup<Guid, Site>> ReadSitesAsync(NpgsqlConnection c, Guid[] ids, CancellationToken ct) =>
        ReadManyAsync(c, SiteSql, ids, r => new Site(r), ct);

    private static Task<ILookup<Guid, string>> ReadSenAsync(NpgsqlConnection c, Guid[] ids, CancellationToken ct) =>
        ReadManyAsync(c, SenSql, ids, r => r.S("name")!, ct);

    private static Task<ILookup<Guid, Responsibility>> ReadResponsibilitiesAsync(NpgsqlConnection c, Guid[] ids, CancellationToken ct) =>
        ReadManyAsync(c, ResponsibilitySql, ids, r => new Responsibility(r), ct);

    private static Task<ILookup<Guid, Federation>> ReadFederationsAsync(NpgsqlConnection c, Guid[] ids, CancellationToken ct) =>
        ReadManyAsync(c, FederationSql, ids, r => new Federation(r), ct);

    private static async Task<ILookup<Guid, T>> ReadManyAsync<T>(
        NpgsqlConnection connection, string sql, Guid[] ids, Func<Row, T> map, CancellationToken ct)
    {
        await using var command = new NpgsqlCommand(sql, connection);
        command.Parameters.Add(new NpgsqlParameter { NpgsqlDbType = NpgsqlDbType.Array | NpgsqlDbType.Uuid, Value = ids });
        await using var reader = await command.ExecuteReaderAsync(ct);
        var row = new Row(reader);
        var items = new List<(Guid, T)>();
        while (await reader.ReadAsync(ct))
        {
            items.Add((row.G("establishment_id"), map(row)));
        }
        return items.ToLookup(i => i.Item1, i => i.Item2);
    }

    // ---------------------------------------------------------------- payload

    /// <returns>The payload, or null when a required fact is missing.</returns>
    private static JsonObject? Build(
        Core e, IEnumerable<Site> sites, IEnumerable<string> sen,
        IEnumerable<Responsibility> responsibilities, IEnumerable<Federation> federations)
    {
        var providerType = Coded(e.TypeCode, e.TypeName);
        var category = Coded(e.CategoryCode, e.CategoryName);
        var status = Coded(e.StatusCode, e.StatusName);
        if (string.IsNullOrWhiteSpace(e.Name) || providerType is null || category is null
            || status is null || e.LastChanged is null)
        {
            return null;
        }

        var byType = responsibilities.ToLookup(r => r.TypeId);
        var trusts = byType[RunByAcademyTrust].ToList();
        var sponsors = byType[SponsoredBy].ToList();
        var councils = byType[MaintainedByLocalAuthority].ToList();
        var foundationTrusts = byType[SupportedByFoundationTrust].ToList();
        var federationList = federations.ToList();

        return new Obj()
            .Add("urn", e.Urn.ToString(CultureInfo.InvariantCulture))
            .Add("establishmentName", e.Name)
            .Add("dfeNumber", e.LaCode is not null && e.EstablishmentNumber is { } number
                ? $"{e.LaCode}/{number:D4}" : null)
            .Add("ukprn", e.Ukprn)
            .Add("providerType", providerType)
            .Add("establishmentTypeCategory", category)
            .Add("educationPhase", Coded(e.PhaseCode, e.PhaseName))
            .Add("establishmentStatus", status)
            .Add("openDate", e.OpenDate)
            .Add("closedDate", e.CloseDate)
            .Add("reasonProviderOpened", Coded(e.OpenedCode, e.OpenedName))
            .Add("reasonProviderClosed", Coded(e.ClosedCode, e.ClosedName))
            .Add("dateLastChangedOrConfirmed", e.LastChanged)
            .Add("establishmentLocationAndContact", new Obj()
                .Add("website", e.Website)
                .Add("phoneNumber", e.Telephone)
                .Add("sites", Array(sites.Select(SiteJson)))
                .Build())
            .Add("administrativeGeography", new Obj()
                .Add("localAuthorityArea", Coded(e.LaCode, e.LaName))
                .Add("governmentOfficeRegion", Coded(e.GorCode, e.GorName))
                .Add("districtAdministrative", Coded(e.DistrictCode, e.DistrictName))
                .Add("administrativeWard", Coded(e.WardCode, e.WardName))
                .Add("parliamentaryConstituency", Coded(e.ConstituencyCode, e.ConstituencyName))
                .Add("urbanRuralClassification", Coded(e.UrbanRuralCode, e.UrbanRuralName))
                .Add("lowerSuperOutputArea", Coded(e.LsoaCode, e.LsoaName))
                .Add("middleSuperOutputArea", Coded(e.MsoaCode, e.MsoaName))
                .Add("governmentStatisticalServiceLocalAuthorityCode", e.GssCode)
                .Build())
            .Add("educationAdmissionsAndProvision", new Obj()
                .Add("statutoryAgeRange", AgeRange(e.LowAge, e.HighAge))
                .Add("genderOfEntry", Coded(e.GenderCode, e.GenderName))
                .Add("admissionsPolicy", Coded(e.AdmissionsCode, e.AdmissionsName))
                .Add("boardingProvision", Coded(e.BoardingCode, e.BoardingName))
                .Add("nurseryProvision", Coded(e.NurseryCode, e.NurseryName))
                .Add("sixthFormProvision", Coded(e.SixthFormCode, e.SixthFormName))
                .Add("specialClassProvision", e.HasSpecialClasses)
                .Add("section41Approval", Coded(e.Section41Code, e.Section41Name))
                .Build())
            .Add("capacityAndPupilMeasures", new Obj()
                .Add("providerCapacity", NonNegative(e.Capacity))
                .Add("numberOfPupilsStudents", NonNegative(e.PupilCount))
                .Add("censusDate", e.CensusDate)
                .Add("pupilsEligibleForFreeSchoolMeals", NonNegative(e.FreeSchoolMeals))
                .Build())
            .Add("faithContext", new Obj()
                .Add("religiousCharacter", Coded(e.ReligiousCharacterCode, e.ReligiousCharacterName))
                .Add("religiousEthos", Coded(e.ReligiousEthosCode, e.ReligiousEthosName))
                .Add("diocese", Coded(e.DioceseCode, e.DioceseName))
                .Build())
            .Add("senAndResourcedProvision", new Obj()
                .Add("typeOfSenProvision", Array(sen.Distinct().Order(StringComparer.Ordinal)
                    .Select(name => new Obj().Add("name", name).Build())))
                .Add("typeOfResourcedProvision", new Obj().Add("name", e.ResourcedProvisionType).Build())
                .Add("resourcedProvisionMeasure", new Obj()
                    .Add("resourcedProvisionPupilCount", NonNegative(e.ResourcedPupils))
                    .Add("resourcedProvisionCapacity", NonNegative(e.ResourcedCapacity))
                    .Build())
                .Add("senUnitMeasure", new Obj()
                    .Add("senUnitPupilCount", NonNegative(e.SenUnitPupils))
                    .Add("senUnitCapacity", NonNegative(e.SenUnitCapacity))
                    .Build())
                .Build())
            .Add("inspectionRecord", new Obj().Add("inspectorateReport", e.OfstedLink).Build())
            .Add("academyTrust", Current(trusts, AcademyTrustJson))
            .Add("sponsor", Current(sponsors, SponsorJson))
            .Add("maintainingLocalAuthority", Current(councils, CouncilJson))
            .Add("federation", CurrentFederation(federationList))
            .Add("foundationTrust", Current(foundationTrusts, FoundationTrustJson))
            .Add("history", new Obj()
                .Add("previousAcademyTrusts", History(trusts, AcademyTrustJson))
                .Add("previousSponsors", History(sponsors, SponsorJson))
                .Add("previousMaintainingLocalAuthorities", History(councils, CouncilJson))
                .Add("previousFederations", FederationHistory(federationList))
                .Add("previousFoundationTrusts", History(foundationTrusts, FoundationTrustJson))
                .Build())
            .Build();
    }

    private static JsonObject? SiteJson(Site s) => new Obj()
        .Add("siteId", s.SiteId.ToString())
        .Add("isMainSite", s.IsMainSite)
        .Add("siteName", s.SiteName)
        .Add("uniquePropertyReferenceNumber", s.Uprn)
        .Add("address", new Obj()
            .Add("addressLine1", s.Line1)
            .Add("addressLine2", s.Line2)
            .Add("addressLine3", s.Line3)
            .Add("townOrCity", s.Town)
            .Add("county", s.County)
            .Add("postcode", s.Postcode)
            .Build())
        .Build();

    private static JsonObject? AcademyTrustJson(Responsibility r) =>
        r.PartyName is null || r.AcademyTrustType is null ? null : new Obj()
            .Add("name", r.PartyName)
            .Add("groupUid", r.GroupUid)
            .Add("groupId", r.GroupId)
            .Add("companiesHouseNumber", r.CompaniesHouseNumber)
            .Add("academyTrustType", r.AcademyTrustType)
            .Add("startDate", r.StartDate)
            .Add("endDate", r.EndDate)
            .Build();

    // An individual sponsor has no published name in this schema yet, so we
    // cannot meet the required "name" and leave the sponsor out.
    private static JsonObject? SponsorJson(Responsibility r) =>
        r.PartyName is null ? null : new Obj()
            .Add("name", r.PartyName)
            .Add("groupUid", r.GroupUid)
            .Add("groupId", r.GroupId)
            .Add("companiesHouseNumber", r.PersonId is null ? r.CompaniesHouseNumber : null)
            .Add("personId", r.PersonId?.ToString())
            .Add("startDate", r.StartDate)
            .Add("endDate", r.EndDate)
            .Build();

    private static JsonObject? CouncilJson(Responsibility r) =>
        r.PartyName is null ? null : new Obj()
            .Add("code", r.LaCode)
            .Add("name", r.PartyName)
            .Add("startDate", r.StartDate)
            .Add("endDate", r.EndDate)
            .Build();

    private static JsonObject? FoundationTrustJson(Responsibility r) =>
        r.PartyName is null ? null : new Obj()
            .Add("name", r.PartyName)
            .Add("groupUid", r.GroupUid)
            .Add("groupId", r.GroupId)
            .Add("companiesHouseNumber", r.CompaniesHouseNumber)
            .Add("startDate", r.StartDate)
            .Add("endDate", r.EndDate)
            .Build();

    private static JsonObject? FederationJson(Federation f) => new Obj()
        .Add("name", f.Name)
        .Add("groupUid", f.GroupUid)
        .Add("groupId", f.GroupId)
        .Add("startDate", f.JoinedDate)
        .Add("endDate", f.LeftDate)
        .Build();

    // At most one current relationship; if the data holds more, the latest start wins.
    private static JsonObject? Current(List<Responsibility> items, Func<Responsibility, JsonObject?> toJson) =>
        items.Where(r => r.IsCurrent)
            .OrderByDescending(r => r.StartDate ?? "", StringComparer.Ordinal)
            .Select(toJson)
            .FirstOrDefault(json => json is not null);

    private static JsonObject? CurrentFederation(List<Federation> items) =>
        items.Where(f => f.IsCurrent)
            .OrderByDescending(f => f.JoinedDate ?? "", StringComparer.Ordinal)
            .Select(FederationJson)
            .FirstOrDefault(json => json is not null);

    // Sort: start date ascending with unknown dates last, then name, then identifiers.
    private static JsonArray? History(List<Responsibility> items, Func<Responsibility, JsonObject?> toJson) =>
        Array(items.Where(r => !r.IsCurrent)
            .OrderBy(r => r.StartDate is null)
            .ThenBy(r => r.StartDate, StringComparer.Ordinal)
            .ThenBy(r => r.PartyName, StringComparer.Ordinal)
            .ThenBy(r => r.GroupUid, StringComparer.Ordinal)
            .ThenBy(r => r.GroupId, StringComparer.Ordinal)
            .Select(toJson));

    private static JsonArray? FederationHistory(List<Federation> items) =>
        Array(items.Where(f => !f.IsCurrent)
            .OrderBy(f => f.JoinedDate is null)
            .ThenBy(f => f.JoinedDate, StringComparer.Ordinal)
            .ThenBy(f => f.Name, StringComparer.Ordinal)
            .Select(FederationJson));

    // Drops nulls and identical duplicates, keeping order. Null when empty.
    private static JsonArray? Array(IEnumerable<JsonObject?> items)
    {
        var seen = new HashSet<string>();
        var array = new JsonArray();
        foreach (var item in items)
        {
            if (item is not null && seen.Add(item.ToJsonString()))
            {
                array.Add(item);
            }
        }
        return array.Count > 0 ? array : null;
    }

    private static JsonObject? Coded(string? code, string? name) =>
        string.IsNullOrWhiteSpace(code) || string.IsNullOrWhiteSpace(name)
            ? null
            : new JsonObject { ["code"] = code, ["name"] = name };

    private static JsonObject? AgeRange(int? low, int? high) =>
        low is >= 0 and <= 19 && high is >= 0 and <= 25 && low <= high
            ? new JsonObject { ["statutoryLowAge"] = low, ["statutoryHighAge"] = high }
            : null;

    private static int? NonNegative(int? value) => value is >= 0 ? value : null;

    // ---------------------------------------------------------------- rows

    private sealed class Core(Row r)
    {
        public Guid Id { get; } = r.G("establishment_id");
        public int Urn { get; } = r.I("urn")!.Value;
        public string? Ukprn { get; } = r.S("ukprn");
        public int? EstablishmentNumber { get; } = r.I("establishment_number");
        public string? Name { get; } = r.S("name");
        public string? OfstedLink { get; } = r.S("ofsted_link");
        public string? TypeCode { get; } = r.S("type_code");
        public string? TypeName { get; } = r.S("type_name");
        public string? CategoryCode { get; } = r.S("category_code");
        public string? CategoryName { get; } = r.S("category_name");
        public string? PhaseCode { get; } = r.S("phase_code");
        public string? PhaseName { get; } = r.S("phase_name");
        public string? StatusCode { get; } = r.S("status_code");
        public string? StatusName { get; } = r.S("status_name");
        public string? OpenDate { get; } = r.D("open_date");
        public string? CloseDate { get; } = r.D("close_date");
        public string? LastChanged { get; } = r.D("last_changed_date");
        public string? OpenedCode { get; } = r.S("opened_code");
        public string? OpenedName { get; } = r.S("opened_name");
        public string? ClosedCode { get; } = r.S("closed_code");
        public string? ClosedName { get; } = r.S("closed_name");
        public string? Website { get; } = r.S("website");
        public string? Telephone { get; } = r.S("telephone_number");
        public string? LaCode { get; } = r.S("la_code");
        public string? LaName { get; } = r.S("la_name");
        public string? GssCode { get; } = r.S("gss_code");
        public string? GorCode { get; } = r.S("gor_code");
        public string? GorName { get; } = r.S("gor_name");
        public string? DistrictCode { get; } = r.S("district_code");
        public string? DistrictName { get; } = r.S("district_name");
        public string? WardCode { get; } = r.S("ward_code");
        public string? WardName { get; } = r.S("ward_name");
        public string? ConstituencyCode { get; } = r.S("constituency_code");
        public string? ConstituencyName { get; } = r.S("constituency_name");
        public string? UrbanRuralCode { get; } = r.S("urban_rural_code");
        public string? UrbanRuralName { get; } = r.S("urban_rural_name");
        public string? LsoaCode { get; } = r.S("lsoa_code");
        public string? LsoaName { get; } = r.S("lsoa_name");
        public string? MsoaCode { get; } = r.S("msoa_code");
        public string? MsoaName { get; } = r.S("msoa_name");
        public int? LowAge { get; } = r.I("lower_statutory_age");
        public int? HighAge { get; } = r.I("upper_statutory_age");
        public string? GenderCode { get; } = r.S("gender_code");
        public string? GenderName { get; } = r.S("gender_name");
        public string? AdmissionsCode { get; } = r.S("admissions_code");
        public string? AdmissionsName { get; } = r.S("admissions_name");
        public string? BoardingCode { get; } = r.S("boarding_code");
        public string? BoardingName { get; } = r.S("boarding_name");
        public string? NurseryCode { get; } = r.S("nursery_code");
        public string? NurseryName { get; } = r.S("nursery_name");
        public string? SixthFormCode { get; } = r.S("sixth_form_code");
        public string? SixthFormName { get; } = r.S("sixth_form_name");
        public bool? HasSpecialClasses { get; } = r.B("has_special_classes");
        public string? Section41Code { get; } = r.S("s41_code");
        public string? Section41Name { get; } = r.S("s41_name");
        public int? Capacity { get; } = r.I("school_capacity");
        public int? PupilCount { get; } = r.I("pupil_count");
        public int? FreeSchoolMeals { get; } = r.I("free_school_meal_measure");
        public string? CensusDate { get; } = r.D("census_date");
        public string? ReligiousCharacterCode { get; } = r.S("religious_character_code");
        public string? ReligiousCharacterName { get; } = r.S("religious_character_name");
        public string? ReligiousEthosCode { get; } = r.S("religious_ethos_code");
        public string? ReligiousEthosName { get; } = r.S("religious_ethos_name");
        public string? DioceseCode { get; } = r.S("diocese_code");
        public string? DioceseName { get; } = r.S("diocese_name");
        public string? ResourcedProvisionType { get; } = r.S("resourced_provision_type");
        public int? ResourcedPupils { get; } = r.I("rp_pupil_count");
        public int? ResourcedCapacity { get; } = r.I("rp_capacity");
        public int? SenUnitPupils { get; } = r.I("su_pupil_count");
        public int? SenUnitCapacity { get; } = r.I("su_capacity");
    }

    private sealed class Site(Row r)
    {
        public Guid SiteId { get; } = r.G("site_id");
        public bool? IsMainSite { get; } = r.B("is_main_site");
        public string? SiteName { get; } = r.S("site_name");
        public string? Uprn { get; } = r.S("uprn");
        public string? Line1 { get; } = r.S("address_line_1");
        public string? Line2 { get; } = r.S("address_line_2");
        public string? Line3 { get; } = r.S("address_line_3");
        public string? Town { get; } = r.S("town");
        public string? County { get; } = r.S("county");
        public string? Postcode { get; } = r.S("postcode");
    }

    private sealed class Responsibility(Row r)
    {
        public int TypeId { get; } = r.I("responsibility_type_id")!.Value;
        public bool IsCurrent { get; } = r.B("is_current") ?? false;
        public string? StartDate { get; } = r.D("start_date");
        public string? EndDate { get; } = r.D("end_date");
        public Guid? PersonId { get; } = r.GOrNull("person_id");
        public string? PartyName { get; } = r.S("party_name");
        public string? AcademyTrustType { get; } = r.S("academy_trust_type");
        public string? CompaniesHouseNumber { get; } = r.S("companies_house_number");
        public string? GroupUid { get; } = r.S("group_uid");
        public string? GroupId { get; } = r.S("group_id");
        public string? LaCode { get; } = r.S("la_code");
    }

    private sealed class Federation(Row r)
    {
        public string? Name { get; } = r.S("name");
        public string? JoinedDate { get; } = r.D("joined_date");
        public string? LeftDate { get; } = r.D("left_date");
        public bool IsCurrent { get; } = r.B("is_current") ?? false;
        public string? GroupUid { get; } = r.S("group_uid");
        public string? GroupId { get; } = r.S("group_id");
    }
}

/// <summary>Typed, null-safe column reads by name.</summary>
internal sealed class Row(NpgsqlDataReader reader)
{
    private int Ordinal(string name) => reader.GetOrdinal(name);

    public string? S(string name)
    {
        var i = Ordinal(name);
        return reader.IsDBNull(i) ? null : Convert.ToString(reader.GetValue(i), CultureInfo.InvariantCulture);
    }

    public int? I(string name)
    {
        var i = Ordinal(name);
        return reader.IsDBNull(i) ? null : reader.GetInt32(i);
    }

    public bool? B(string name)
    {
        var i = Ordinal(name);
        return reader.IsDBNull(i) ? null : reader.GetBoolean(i);
    }

    public string? D(string name)
    {
        var i = Ordinal(name);
        return reader.IsDBNull(i)
            ? null
            : reader.GetFieldValue<DateOnly>(i).ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
    }

    public Guid G(string name) => reader.GetGuid(Ordinal(name));

    public Guid? GOrNull(string name)
    {
        var i = Ordinal(name);
        return reader.IsDBNull(i) ? null : reader.GetGuid(i);
    }
}

/// <summary>
/// Builds a JSON object that follows the representation rules: it leaves out
/// nulls, empty strings, empty objects and empty arrays, and keeps 0 and false.
/// </summary>
internal sealed class Obj
{
    private readonly JsonObject _object = new();

    public Obj Add(string name, JsonNode? value)
    {
        if (value is not null && value is not JsonObject { Count: 0 } && value is not JsonArray { Count: 0 })
        {
            _object[name] = value;
        }
        return this;
    }

    public Obj Add(string name, string? value) =>
        string.IsNullOrWhiteSpace(value) ? this : Add(name, JsonValue.Create(value));

    public Obj Add(string name, int? value) =>
        value is null ? this : Add(name, JsonValue.Create(value.Value));

    public Obj Add(string name, bool? value) =>
        value is null ? this : Add(name, JsonValue.Create(value.Value));

    public JsonObject? Build() => _object.Count > 0 ? _object : null;
}
