using System.Text.Json.Nodes;

namespace ApiDemo;

/// <summary>Bundles the maintained demo contract with its shared publication schemas.</summary>
public static class OpenApiDocument
{
    public static JsonObject Load(string directory)
    {
        var document = JsonNode.Parse(File.ReadAllText(Path.Combine(directory, "openapi.json")))!.AsObject();
        var published = JsonNode.Parse(File.ReadAllText(Path.Combine(directory, "published-establishment-api.openapi.json")))!;
        var schemas = document["components"]!["schemas"]!.AsObject();
        foreach (var (name, schema) in published["definitions"]!.AsObject())
        {
            schemas[name] = schema!.DeepClone();
        }
        RewriteReferences(document);
        return document;
    }

    private static void RewriteReferences(JsonNode? node)
    {
        if (node is JsonObject obj)
        {
            foreach (var name in obj.Select(property => property.Key).ToArray())
            {
                if (name == "$ref" && obj[name] is JsonValue value && value.TryGetValue<string>(out var reference)
                    && reference.StartsWith("#/definitions/", StringComparison.Ordinal))
                {
                    obj[name] = reference.Replace("#/definitions/", "#/components/schemas/", StringComparison.Ordinal);
                }
                else
                {
                    RewriteReferences(obj[name]);
                }
            }
        }
        else if (node is JsonArray array)
        {
            foreach (var child in array) RewriteReferences(child);
        }
    }
}
