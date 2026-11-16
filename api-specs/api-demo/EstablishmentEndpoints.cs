using System.Text.Json.Nodes;
using System.Text.RegularExpressions;
using Npgsql;

namespace ApiDemo;

/// <summary>Request validation and establishment/reference-data endpoints.</summary>
public static partial class EstablishmentEndpoints
{
    private const string CollectionPath = "/v1/establishments";
    private const string TypesPath = "/v1/establishment-types";
    private const string OpenApiPath = "/openapi/v1.json";

    [GeneratedRegex("^[1-9][0-9]{0,5}$")]
    private static partial Regex UrnPattern();

    [GeneratedRegex("\\A[0-9]{2}\\z")]
    private static partial Regex TypeCodePattern();

    public static async Task HandleAsync(HttpContext context, EstablishmentStore store, ILogger log, JsonObject specification)
    {
        try
        {
            await HandleCoreAsync(context, store, specification);
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

    private static async Task HandleCoreAsync(HttpContext context, EstablishmentStore store, JsonObject specification)
    {
        var request = context.Request;
        var path = request.Path.Value ?? "";

        // 1. Match the path exactly: lowercase segments, no trailing slash.
        string? urnSegment = null;
        if (path == CollectionPath || path == TypesPath || path == OpenApiPath)
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

        if (path == TypesPath || path == OpenApiPath)
        {
            if (request.Query.Count > 0)
            {
                await Responses.WriteProblem(context, StatusCodes.Status400BadRequest,
                    "unsupported-query-parameter", $"{path} does not accept query parameters.",
                    request.Query.Keys.Order(StringComparer.Ordinal)
                        .Select(key => new ValidationError("query", key, "This query parameter is not supported.")).ToList());
                return;
            }
            JsonNode payload = path == OpenApiPath ? specification : await store.LoadEstablishmentTypesAsync(context.RequestAborted);
            await Responses.WriteRepresentation(context, payload);
        }
        else if (urnSegment is null)
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
        var unsupported = query.Keys.Where(key => key is not ("status" or "establishmenttype" or "page" or "pageSize")).Order(StringComparer.Ordinal).ToList();
        if (unsupported.Count > 0)
        {
            await Responses.WriteProblem(context, StatusCodes.Status400BadRequest,
                "unsupported-query-parameter", "Only status, establishmenttype, page and pageSize query parameters are supported.",
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

        string[]? typeCodes = null;
        if (query.TryGetValue("establishmenttype", out var typeValues))
        {
            var codes = typeValues.Count == 1 ? typeValues[0]?.Split(',') : null;
            if (codes is null || codes.Any(code => !TypeCodePattern().IsMatch(code)))
            {
                await Responses.WriteProblem(context, StatusCodes.Status400BadRequest,
                    "invalid-establishmenttype-filter", "establishmenttype must be a comma-separated list of two-digit codes, given once.",
                    [new("query", "establishmenttype", "Expected codes such as 01,02,03, without whitespace or empty entries.")]);
                return;
            }
            typeCodes = codes.Distinct(StringComparer.Ordinal).Order(StringComparer.Ordinal).ToArray();
        }

        var page = 1;
        var pageSize = 1000;
        var pagingErrors = new List<ValidationError>();
        foreach (var name in new[] { "page", "pageSize" })
        {
            if (!query.TryGetValue(name, out var pagingValues)) continue;
            var maximum = name == "pageSize" ? 10000 : int.MaxValue;
            if (pagingValues.Count != 1 || !int.TryParse(pagingValues[0],
                    System.Globalization.NumberStyles.None, System.Globalization.CultureInfo.InvariantCulture,
                    out var number) || number < 1 || number > maximum)
            {
                pagingErrors.Add(new("query", name, $"Expected one integer between 1 and {maximum}."));
            }
            else if (name == "page") page = number;
            else pageSize = number;
        }
        if (pagingErrors.Count > 0)
        {
            await Responses.WriteProblem(context, StatusCodes.Status400BadRequest,
                "invalid-pagination", "Invalid page or pageSize.", pagingErrors);
            return;
        }

        var result = await store.LoadAsync(urn: null, statusCode, context.RequestAborted,
            pageSize, ((long)page - 1) * pageSize, typeCodes);
        if (await WritePublicationProblemAsync(context, result))
        {
            return;
        }

        string? next = null;
        if (result.HasNextPage)
        {
            var parameters = new Dictionary<string, string?>
            {
                ["page"] = ((long)page + 1).ToString(System.Globalization.CultureInfo.InvariantCulture),
                ["pageSize"] = pageSize.ToString(System.Globalization.CultureInfo.InvariantCulture)
            };
            if (statusCode is not null) parameters["status"] = query["status"].ToString();
            if (typeCodes is not null) parameters["establishmenttype"] = string.Join(',', typeCodes);
            next = Microsoft.AspNetCore.WebUtilities.QueryHelpers.AddQueryString(
                context.Request.PathBase.Add(CollectionPath).Value!, parameters);
        }
        await Responses.WriteRepresentation(context, new JsonObject
        {
            ["items"] = new JsonArray([.. result.Establishments]),
            ["page"] = page,
            ["pageSize"] = pageSize,
            ["hasNextPage"] = result.HasNextPage,
            ["next"] = next
        });
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
