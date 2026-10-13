# Render reviewed fixture data separately from reusable SQL behaviour.
function ConvertTo-ReviewedFixtureSql {
    param([Parameter(Mandatory)][string]$Template, [Parameter(Mandatory)][string]$FixtureJson)
    $review = $FixtureJson | ConvertFrom-Json
    if ($review.reviewStatus -ne 'accepted' -or [string]::IsNullOrWhiteSpace($review.reviewEvidence)) {
        throw 'A reviewed fixture requires accepted status and explicit evidence.'
    }
    $hashAlgorithm = [System.Security.Cryptography.SHA256]::Create()
    try {
        $hash = ([BitConverter]::ToString($hashAlgorithm.ComputeHash([Text.Encoding]::UTF8.GetBytes($FixtureJson)))).Replace('-','').ToLowerInvariant()
    } finally { $hashAlgorithm.Dispose() }
    return $Template.Replace('__REVIEWED_FIXTURE_JSON__',$FixtureJson.Replace("'","''")).Replace('__REVIEWED_FIXTURE_SHA256__',$hash)
}
