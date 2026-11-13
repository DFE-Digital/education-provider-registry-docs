using System.Buffers.Text;
using System.Globalization;
using System.IO.Compression;
using System.Security.Cryptography;
using System.Text.Encodings.Web;
using System.Text.Json;
using System.Text.Json.Nodes;
using Microsoft.AspNetCore.WebUtilities;

namespace ApiDemo;

public sealed record ValidationError(string Location, string Name, string Reason);

/// <summary>Writing responses: problem details, content negotiation, ETags and 304s.</summary>
public static class Responses
{
    public const string ApiVersion = "1.0.0";
    public const string ApiStatus = "beta";
    public const string RequestIdKey = "RequestId";

    private const string JsonType = "application/json; charset=utf-8";
    private const string ProblemType = "application/problem+json; charset=utf-8";

    // Relaxed escaping keeps names such as "Children's centre" readable.
    // Safe here because responses are JSON, never embedded in HTML.
    public static readonly JsonSerializerOptions Json = new()
    {
        WriteIndented = false,
        Encoder = JavaScriptEncoder.UnsafeRelaxedJsonEscaping,
    };

    public static string Rfc3339(DateTimeOffset value) =>
        value.UtcDateTime.ToString("yyyy-MM-dd'T'HH:mm:ss'Z'", CultureInfo.InvariantCulture);

    public static Guid RequestId(HttpContext context) =>
        context.Items[RequestIdKey] is Guid id ? id : Guid.NewGuid();

    public static async Task WriteProblem(
        HttpContext context, int status, string code, string detail,
        IReadOnlyList<ValidationError>? errors = null, int? retryAfterSeconds = null)
    {
        var requestId = RequestId(context);
        var body = new JsonObject
        {
            ["type"] = "about:blank",
            ["title"] = ReasonPhrases.GetReasonPhrase(status),
            ["status"] = status,
            ["detail"] = detail,
            ["instance"] = $"urn:uuid:{requestId}",
            ["code"] = code,
            ["requestId"] = requestId.ToString(),
        };
        if (errors is { Count: > 0 })
        {
            body["errors"] = new JsonArray(errors.Select(e => (JsonNode)new JsonObject
            {
                ["location"] = e.Location,
                ["name"] = e.Name,
                ["reason"] = e.Reason,
            }).ToArray());
        }

        var response = context.Response;
        response.StatusCode = status;
        response.ContentType = ProblemType;
        response.Headers.CacheControl = "no-store";
        if (status == StatusCodes.Status405MethodNotAllowed)
        {
            response.Headers.Allow = "GET";
        }
        if (retryAfterSeconds is > 0)
        {
            response.Headers.RetryAfter = retryAfterSeconds.Value.ToString(CultureInfo.InvariantCulture);
        }
        await response.WriteAsync(body.ToJsonString(Json));
    }

    /// <summary>
    /// Negotiates, serialises, tags and writes a 200 or 304.
    /// Follows the contract's conditional retrieval steps 2 to 7.
    /// </summary>
    public static async Task WriteRepresentation(HttpContext context, JsonNode payload)
    {
        var request = context.Request;

        if (!Negotiation.AcceptsJson(request.Headers.Accept.ToString(), request.Headers.ContainsKey("Accept")))
        {
            await WriteProblem(context, StatusCodes.Status406NotAcceptable, "not-acceptable",
                "The only available representation is application/json.");
            return;
        }

        var coding = Negotiation.ChooseCoding(
            request.Headers.AcceptEncoding.ToString(), request.Headers.ContainsKey("Accept-Encoding"));
        if (coding is null)
        {
            await WriteProblem(context, StatusCodes.Status406NotAcceptable, "not-acceptable",
                "The only available content codings are gzip and identity.");
            return;
        }

        var bytes = JsonSerializer.SerializeToUtf8Bytes(payload, Json);
        if (coding == "gzip")
        {
            bytes = Gzip(bytes);
        }
        var etag = $"\"{Base64Url.EncodeToString(SHA256.HashData(bytes))}\"";

        var response = context.Response;
        response.Headers.ETag = etag;
        response.Headers.CacheControl = "public, no-cache";
        response.Headers.Vary = "Accept, Accept-Encoding";

        if (Negotiation.IfNoneMatchMatches(request.Headers.IfNoneMatch.ToString(), etag))
        {
            response.StatusCode = StatusCodes.Status304NotModified;
            return;
        }

        response.StatusCode = StatusCodes.Status200OK;
        response.ContentType = JsonType;
        if (coding == "gzip")
        {
            response.Headers.ContentEncoding = "gzip";
        }
        response.ContentLength = bytes.Length;
        await response.Body.WriteAsync(bytes);
    }

    // Same input gives the same bytes: .NET writes a zero timestamp in the gzip header.
    private static byte[] Gzip(byte[] input)
    {
        using var output = new MemoryStream();
        using (var gzip = new GZipStream(output, CompressionLevel.Optimal, leaveOpen: true))
        {
            gzip.Write(input);
        }
        return output.ToArray();
    }
}

/// <summary>Accept, Accept-Encoding and If-None-Match handling.</summary>
public static class Negotiation
{
    public static bool AcceptsJson(string header, bool present)
    {
        if (!present || string.IsNullOrWhiteSpace(header))
        {
            return true;
        }

        // The most specific matching range decides the quality value.
        double? exact = null, typeWildcard = null, anyWildcard = null;
        foreach (var (value, q) in ParseList(header))
        {
            switch (value)
            {
                case "application/json": exact = Math.Max(exact ?? 0, q); break;
                case "application/*": typeWildcard = Math.Max(typeWildcard ?? 0, q); break;
                case "*/*": anyWildcard = Math.Max(anyWildcard ?? 0, q); break;
            }
        }
        var quality = exact ?? typeWildcard ?? anyWildcard ?? 0;
        return quality > 0;
    }

    /// <returns>"gzip", "identity", or null when neither is acceptable.</returns>
    public static string? ChooseCoding(string header, bool present)
    {
        if (!present)
        {
            return "identity";
        }

        double? gzip = null, identity = null, any = null;
        foreach (var (value, q) in ParseList(header))
        {
            switch (value)
            {
                case "gzip" or "x-gzip": gzip = Math.Max(gzip ?? 0, q); break;
                case "identity": identity = Math.Max(identity ?? 0, q); break;
                case "*": any = Math.Max(any ?? 0, q); break;
            }
        }

        var gzipQ = gzip ?? any ?? 0;
        // Identity stays acceptable unless it, or "*", is explicitly refused.
        var identityQ = identity ?? any ?? 1;

        if (gzipQ > 0 && gzipQ >= identityQ)
        {
            return "gzip";
        }
        return identityQ > 0 ? "identity" : null;
    }

    public static bool IfNoneMatchMatches(string header, string etag)
    {
        if (string.IsNullOrWhiteSpace(header))
        {
            return false;
        }
        if (header.Trim() == "*")
        {
            return true;
        }
        // Weak comparison: ignore any W/ prefix on either side.
        return header.Split(',')
            .Select(tag => tag.Trim())
            .Select(tag => tag.StartsWith("W/", StringComparison.Ordinal) ? tag[2..] : tag)
            .Any(tag => tag == etag);
    }

    private static IEnumerable<(string Value, double Q)> ParseList(string header)
    {
        foreach (var element in header.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
        {
            var parts = element.Split(';', StringSplitOptions.TrimEntries);
            var value = parts[0].ToLowerInvariant();
            double q = 1;
            foreach (var parameter in parts.Skip(1))
            {
                var pair = parameter.Split('=', 2, StringSplitOptions.TrimEntries);
                if (pair.Length == 2 && pair[0].Equals("q", StringComparison.OrdinalIgnoreCase))
                {
                    // A malformed quality value counts as "not acceptable".
                    q = double.TryParse(pair[1], NumberStyles.AllowDecimalPoint, CultureInfo.InvariantCulture, out var parsed)
                        && parsed is >= 0 and <= 1 ? parsed : 0;
                }
            }
            if (value.Length > 0)
            {
                yield return (value, q);
            }
        }
    }
}
