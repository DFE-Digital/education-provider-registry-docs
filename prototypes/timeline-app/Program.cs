using Npgsql;
using ReorganisationTimeline;

// One-page reorganisation timeline for any establishment in the local database.
//   GET /                      the timeline page
//   GET /api/timeline?urn=...  reorganisations for that URN, optionally with connected ones

// Read appsettings.json and wwwroot from next to the program, wherever it is started from.
var builder = WebApplication.CreateBuilder(new WebApplicationOptions
{
    Args = args,
    ContentRootPath = AppContext.BaseDirectory,
    WebRootPath = Path.Combine(AppContext.BaseDirectory, "wwwroot"),
});

var connectionString = builder.Configuration.GetConnectionString("Registry")
    ?? throw new InvalidOperationException("ConnectionStrings:Registry is not set.");
builder.Services.AddSingleton(new TimelineStore(NpgsqlDataSource.Create(connectionString)));

var app = builder.Build();
app.UseDefaultFiles();
app.UseStaticFiles();

app.MapGet("/api/timeline", async (string? urn, bool? connected, TimelineStore store, ILogger<TimelineStore> log, CancellationToken ct) =>
{
    if (!int.TryParse(urn, out var value) || value < 1 || value > 999999)
    {
        return Results.BadRequest(new { error = "Enter a URN between 1 and 999999." });
    }
    try
    {
        return Results.Ok(await store.LoadAsync(value, connected ?? true, ct));
    }
    catch (MissingSchemaException e)
    {
        return Results.Json(new { error = e.Message }, statusCode: StatusCodes.Status503ServiceUnavailable);
    }
    catch (NpgsqlException e)
    {
        log.LogError(e, "Database read failed for URN {Urn}", value);
        return Results.Json(new { error = "Could not read the database. " + e.Message },
            statusCode: StatusCodes.Status503ServiceUnavailable);
    }
});

app.Run();
