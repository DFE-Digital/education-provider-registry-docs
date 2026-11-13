using System.Diagnostics;
using System.Threading.RateLimiting;
using ApiDemo;
using Npgsql;

// Local demo of the Published Establishment API (contract 1.0.0).
// Reads the local establishment_local PostgreSQL database and serves:
//   GET /v1/establishments/{URN}
//   GET /v1/establishments[?status=open|closed&page=1&pageSize=1000]

// Read appsettings.json from next to the program, wherever it is started from.
var builder = WebApplication.CreateSlimBuilder(new WebApplicationOptions
{
    Args = args,
    ContentRootPath = AppContext.BaseDirectory,
});
builder.WebHost.ConfigureKestrel(options => options.AddServerHeader = false);

var connectionString = builder.Configuration.GetConnectionString("Registry")
    ?? throw new InvalidOperationException("ConnectionStrings:Registry is not set.");
builder.Services.AddSingleton(new EstablishmentStore(NpgsqlDataSource.Create(connectionString)));

var permitLimit = builder.Configuration.GetValue("RateLimit:PermitLimit", 120);
var windowSeconds = builder.Configuration.GetValue("RateLimit:WindowSeconds", 60);
builder.Services.AddRateLimiter(options =>
{
    options.GlobalLimiter = PartitionedRateLimiter.Create<HttpContext, string>(context =>
        RateLimitPartition.GetFixedWindowLimiter(
            context.Connection.RemoteIpAddress?.ToString() ?? "unknown",
            _ => new FixedWindowRateLimiterOptions
            {
                PermitLimit = permitLimit,
                Window = TimeSpan.FromSeconds(windowSeconds),
                QueueLimit = 0,
            }));
    options.OnRejected = (rejected, _) => new ValueTask(Responses.WriteProblem(
        rejected.HttpContext, StatusCodes.Status429TooManyRequests, "rate-limit-exceeded",
        "Too many requests. Try again later.", retryAfterSeconds: windowSeconds));
});

var app = builder.Build();
var store = app.Services.GetRequiredService<EstablishmentStore>();
var log = app.Services.GetRequiredService<ILoggerFactory>().CreateLogger("api");

// Headers that go on every response, including 429s from the rate limiter.
app.Use(async (context, next) =>
{
    var requestId = Guid.NewGuid();
    context.Items[Responses.RequestIdKey] = requestId;
    context.Response.OnStarting(() =>
    {
        var headers = context.Response.Headers;
        headers["API-Version"] = Responses.ApiVersion;
        headers["API-Status"] = Responses.ApiStatus;
        headers["X-Request-ID"] = requestId.ToString();
        if (store.LastKnownRefresh is { } refreshed)
        {
            headers["Data-Last-Refreshed-At"] = Responses.Rfc3339(refreshed);
        }
        return Task.CompletedTask;
    });

    var timer = Stopwatch.StartNew();
    await next(context);
    log.LogInformation("{Method} {Path}{Query} -> {Status} in {Elapsed} ms",
        context.Request.Method, context.Request.Path, context.Request.QueryString,
        context.Response.StatusCode, timer.ElapsedMilliseconds);
});

app.UseRateLimiter();

// One terminal handler, so we control exact path matching. ASP.NET routing
// would accept a trailing slash, which the contract says must return 404.
app.Run(context => EstablishmentEndpoints.HandleAsync(context, store, log));

app.Run();
