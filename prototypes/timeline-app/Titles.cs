namespace ReorganisationTimeline;

/// <summary>Plain-English titles, because the database stores no title for a reorganisation.</summary>
public static class Titles
{
    public static string ForReorganisation(string pattern, string? cause, IReadOnlyList<ItemParticipant> people)
    {
        string Names(string outcome) => Join(people.Where(p => p.Outcome == outcome).Select(p => p.Name).ToList());
        var closed = Names("Closed");
        var opened = Names("Opened");

        return pattern switch
        {
            "Replacement" when closed != "" && cause == "Academy conversion" => $"{closed} converted to an academy",
            "Replacement" when closed != "" => $"{closed} replaced",
            "Absorption" when closed != "" => $"{closed} absorbed",
            "Amalgamation" when opened != "" => $"{opened} formed",
            "Split" when closed != "" => $"{closed} split",
            "Spin-out" when opened != "" => $"{opened} spun out",
            "Transfer between continuing establishments" => "Provision transferred between establishments",
            _ when closed != "" => $"{closed} reorganised",
            _ => "Establishments reorganised",
        };
    }

    public static string ForPair(string kind, string from, string to) =>
        kind == "succession" ? $"{to} succeeded {from}" : $"Provision transferred from {from} to {to}";

    private static string Join(IReadOnlyList<string> names) => names.Count switch
    {
        0 => "",
        1 => names[0],
        2 => $"{names[0]} and {names[1]}",
        _ => string.Join(", ", names.Take(names.Count - 1)) + " and " + names[^1],
    };
}
