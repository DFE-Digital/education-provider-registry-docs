# Reorganisation timeline

A one-page .NET 10 web app that shows an establishment's reorganisations as a timeline, latest at the top. Enter a URN to see the reorganisations it took part in. Tick "Include connected reorganisations" to follow predecessors, successors and provision transfers to related establishments.

It reads the same local PostgreSQL database as the [API demo](../../api-specs/api-demo/README.md), with the same read-only connection string.

## Run it

You need the .NET 10 SDK and a local establishment database built with the current schema.

```powershell
cd education-provider-registry-docs/prototypes/timeline-app
dotnet run
```

Then open <http://localhost:5090>. The API demo uses port 5080, so you can run both at once.

To open a URN directly, use `http://localhost:5090/?urn=135771`.

## Connecting to a different database

The connection string is `ConnectionStrings:Registry` in [appsettings.json](appsettings.json). The default is `establishment_local` on port 5432. To use another database, set an environment variable before `dotnet run`:

```powershell
$env:ConnectionStrings__Registry = 'Host=127.0.0.1;Port=5433;Database=establishment;Username=postgres;Options=-c default_transaction_read_only=on'
```

The password comes from your `pgpass.conf`, as it does for the API demo.

## What it shows

- **Reorganisations** come from `establishment_reorganisation` and its participants, effects, successions and provision transfers.
- **Pairs without a reorganisation** appear as their own entries, with the badge "Pair without a reorganisation". The pattern filters do not hide them.
- **Dates:** where a reorganisation has no effective date, the page uses the earliest opening date of an establishment it opened. Failing that, it uses the latest closing date of one it closed. Entries with neither come last, under "Undated".
- **Titles** are generated from the pattern, cause and participants, because the database stores no title. For example, "Joseph Priestley College absorbed".
- **Connected search** stops after 20 steps or 300 entries, and the summary says so.

Every establishment can be looked up. 

If the database was built before the reorganisation tables existed, the page says so. Rebuild it with the local schema automation.

## Files

| File | Purpose |
| --- | --- |
| [Program.cs](Program.cs) | Serves the page and `GET /api/timeline?urn=…&connected=true` |
| [TimelineStore.cs](TimelineStore.cs) | Reads the database in one read-only transaction and follows connected establishments |
| [Titles.cs](Titles.cs) | Plain-English titles for each pattern |
| [wwwroot/](wwwroot/) | The page: `index.html`, `app.css` and `app.js` |
