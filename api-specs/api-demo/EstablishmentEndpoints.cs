using System.Text.Json.Nodes;
using System.Text.RegularExpressions;
using Npgsql;

namespace ApiDemo;

/// <summary>Request validation and the two endpoints.</summary>
public static partial class EstablishmentEndpoints
{
    private const string CollectionPath = "/v1/establishments";

    [GeneratedRegex("^[1-9][0-9]{0,5}$")]
    private static partial Regex UrnPattern();

    public static async Task HandleAsync(HttpContext context, EstablishmentStore store, ILogger log)
    {
        try
        {
            await HandleCoreAsync(context, store);
        }
        catch (Exception ex) when (ex is NpgsqlException or TimeoutException)
        {
            log.LogError(ex, "Database unavailable");
            await Responses.WriteProblem(context, StatusCodes.Status503ServiceUnavailable,
                "publication-unavailable", "The public data is not available right now.");
        }
        catch (Exception ex)
        {
            // Never leak SQL, stack traces or unpublished data to the caller.
            log.LogError(ex, "Unexpected failure");
            if (!context.Response.HasStarted)
            {
                await Responses.WriteProblem(context, StatusCodes.Status500InternalServerError,
                    "internal-error", "An unexpected error occurred.");
            }
        }
    }

    private static async Task HandleCoreAsync(HttpContext context, EstablishmentStore store)
    {
        var request = context.Request;
        var path = request.Path.Value ?? "";

        // 1. Match the path exactly: lowercase segments, no trailing slash.
        string? urnSegment = null;
        if (path == CollectionPath)
        {
            // collection
        }
        else if (path.StartsWith(CollectionPath + "/", StringComparison.Ordinal)
                 && path.Length > CollectionPath.Length + 1
                 && path.IndexOf('/', CollectionPath.Length + 1) < 0)
        {
            urnSegment = path[(CollectionPath.Length + 1)..];
        }
        else
        {
            await Responses.WriteProblem(context, StatusCodes.Status404NotFound,
                "establishment-not-found", "No resource matches this path.");
            return;
        }

        // 2. Method.
        if (!HttpMethods.IsGet(request.Method))
        {
            await Responses.WriteProblem(context, StatusCodes.Status405MethodNotAllowed,
                "method-not-allowed", "Only GET is supported.");
            return;
        }

        // 3. Request body must be empty.
        if (await HasBodyAsync(request))
        {
            await Responses.WriteProblem(context, StatusCodes.Status400BadRequest,
                "unexpected-request-body", "GET requests must not have a body.",
                [new("body", "body", "A request body is not allowed.")]);
            return;
        }

        if (urnSegment is null)
        {
            await CollectionAsync(context, store);
        }
        else
        {
            await DetailAsync(context, store, urnSegment);
        }
    }

    private static async Task DetailAsync(HttpContext context, EstablishmentStore store, string urnSegment)
    {
        if (!UrnPattern().IsMatch(urnSegment))
        {
            await Responses.WriteProblem(context, StatusCodes.Status400BadRequest, "invalid-urn",
                "URN must contain 1 to 6 digits, start with a non-zero digit and be between 1 and 999999.",
                [new("path", "URN", "Expected a decimal URN without leading zeroes.")]);
            return;
        }

        var result = await store.LoadAsync(int.Parse(urnSegment), statusCode: null, context.RequestAborted);
        if (await WritePublicationProblemAsync(context, result))
        {
            return;
        }
        if (result.Establishments.Count == 0)
        {
            await Responses.WriteProblem(context, StatusCodes.Status404NotFound,
                "establishment-not-found", $"No published establishment has URN {urnSegment}.");
            return;
        }

        await Responses.WriteRepresentation(context, result.Establishments[0]);
    }

    private static async Task CollectionAsync(HttpContext context, EstablishmentStore store)
    {
        var query = context.Request.Query;
        var unsupported = query.Keys.Where(key => key != "status").Order(StringComparer.Ordinal).ToList();
        if (unsupported.Count > 0)
        {
            await Responses.WriteProblem(context, StatusCodes.Status400BadRequest,
                "unsupported-query-parameter", "Only the status query parameter is supported.",
                unsupported.Select(key => new ValidationError("query", key, "This query parameter is not supported.")).ToList());
            return;
        }

        int? statusCode = null;
        if (query.TryGetValue("status", out var values))
        {
            // Case-sensitive, untrimmed, exactly one value.
            statusCode = values.Count == 1 ? values[0] switch { "open" => 1, "closed" => 2, _ => null } : null;
            if (statusCode is null)
            {
                await Responses.WriteProblem(context, StatusCodes.Status400BadRequest,
                    "invalid-status-filter", "status must be open or closed, given once.",
                    [new("query", "status", "Expected exactly one value: open or closed.")]);
                return;
            }
        }

        var result = await store.LoadAsync(urn: null, statusCode, context.RequestAborted);
        if (await WritePublicationProblemAsync(context, result))
        {
            return;
        }

        await Responses.WriteRepresentation(context, new JsonArray([.. result.Establishments]));
    }

    private static async Task<bool> WritePublicationProblemAsync(HttpContext context, LoadResult result)
    {
        if (result.RefreshedAt is null)
        {
            await Responses.WriteProblem(context, StatusCodes.Status503ServiceUnavailable,
                "publication-unavailable", "No public data has been loaded yet.");
            return true;
        }
        if (result.IncompleteUrns.Count > 0)
        {
            await Responses.WriteProblem(context, StatusCodes.Status503ServiceUnavailable,
                "publication-incomplete", "Required published facts are missing for a matching establishment.");
            return true;
        }
        return false;
    }

    private static async Task<bool> HasBodyAsync(HttpRequest request)
    {
        if (request.ContentLength is > 0)
        {
            return true;
        }
        if (request.ContentLength is null && request.Headers.TransferEncoding.Count > 0)
        {
            var buffer = new byte[1];
            return await request.Body.ReadAsync(buffer) > 0;
        }
        return false;
    }
}
