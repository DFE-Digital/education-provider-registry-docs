param([string]$BaseUrl = 'http://localhost:5080')

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Net.Http
$client = [Net.Http.HttpClient]::new()
$client.BaseAddress = [uri]$BaseUrl
$client.Timeout = [TimeSpan]::FromSeconds(30)
$script:checks = 0

function Assert-That([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw $Message }
    $script:checks++
}

function Request([string]$Path, [int]$Status = 200, [hashtable]$Headers = @{}, [string]$Method = 'GET', [bool]$ParseJson = $true) {
    $request = [Net.Http.HttpRequestMessage]::new([Net.Http.HttpMethod]::new($Method), $Path)
    foreach ($name in $Headers.Keys) { $null = $request.Headers.TryAddWithoutValidation($name, [string]$Headers[$name]) }
    try {
        $response = $client.SendAsync($request).GetAwaiter().GetResult()
        try {
            $text = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
            Assert-That ([int]$response.StatusCode -eq $Status) "$Path returned $([int]$response.StatusCode), expected ${Status}: $text"
            return [pscustomobject]@{
                Text = $text
                Json = if ($text -and $ParseJson) { ConvertFrom-Json -InputObject $text } else { $null }
                ContentType = [string]$response.Content.Headers.ContentType
                ETag = [string]$response.Headers.ETag
            }
        } finally { $response.Dispose() }
    } finally { $request.Dispose() }
}

try {
    $ui = Request '/swagger' -ParseJson $false
    Assert-That ($ui.ContentType.StartsWith('text/html') -and $ui.Text.Contains('EPR API demo')) 'Swagger UI HTML was not served.'
    $scripts = [regex]::Matches($ui.Text, 'src="([^"?]+\.js)')
    Assert-That ($scripts.Count -gt 0) 'Swagger UI has no script resources.'
    $initializers = ''
    foreach ($script in $scripts) {
        $resourceUri = [uri]::new([uri]($BaseUrl.TrimEnd('/') + '/swagger/index.html'), $script.Groups[1].Value)
        Assert-That ($resourceUri.Authority -eq ([uri]$BaseUrl).Authority) 'Swagger UI depends on external scripts.'
        $asset = Request $resourceUri.PathAndQuery -ParseJson $false
        $initializers += $asset.Text
    }
    Assert-That ($initializers.Contains('../openapi/v1.json') -or $ui.Text.Contains('../openapi/v1.json')) 'Swagger UI is not configured for our OpenAPI resource.'
    $css = Request '/swagger/swagger-ui.css' -ParseJson $false
    Assert-That ($css.ContentType.StartsWith('text/css')) 'Swagger UI CSS was not served.'

    $documentResponse = Request '/openapi/v1.json'
    $document = $documentResponse.Json
    Assert-That ($document.openapi -eq '3.0.3') 'Expected an OpenAPI 3 document.'
    Assert-That ($document.servers[0].url -eq '/') 'The document must use the current origin.'
    $filter = @($document.paths.'/v1/establishments'.get.parameters | Where-Object { $_.name -eq 'establishmenttype' })
    Assert-That ($filter.Count -eq 1 -and $filter[0].style -eq 'form' -and $filter[0].explode -eq $false -and $filter[0].schema.items.type -eq 'string') 'OpenAPI CSV array definition missing.'
    Assert-That ($filter[0].description.Contains('OR') -and $filter[0].description.Contains('AND')) 'Filter semantics are not documented.'
    Assert-That ($null -ne $document.paths.'/v1/establishment-types') 'Lookup resource missing from the contract.'
    $references = [regex]::Matches($documentResponse.Text, '"\$ref"\s*:\s*"([^"]+)"')
    foreach ($reference in $references) {
        $pointer = $reference.Groups[1].Value
        Assert-That ($pointer.StartsWith('#/')) "External reference remains: $pointer"
        $node = $document
        foreach ($segment in $pointer.Substring(2).Split('/')) {
            $name = $segment.Replace('~1', '/').Replace('~0', '~')
            $property = $node.PSObject.Properties[$name]
            Assert-That ($null -ne $property) "Unresolved OpenAPI reference: $pointer"
            $node = $property.Value
        }
    }
    $null = Request '/openapi/v1.json' 304 @{ 'If-None-Match' = $documentResponse.ETag }
    $null = Request '/openapi/v1.json' 405 @{} 'POST'
    $null = Request '/openapi/v1.json?unknown=1' 400
    $null = Request '/openapi/v1.json/' 404

    $lookupResponse = Request '/v1/establishment-types'
    $types = @($lookupResponse.Json)
    Assert-That ($lookupResponse.Text.TrimStart().StartsWith('[')) 'Lookup must return a bare array.'
    Assert-That ($types.Count -gt 4) 'Use a populated dictionary; the endpoint must return more than the four sample rows.'
    $sortedCodes = @($types.code | Sort-Object -CaseSensitive)
    Assert-That (($types.code -join ',') -ceq ($sortedCodes -join ',')) 'Types are not ordered by code.'
    Assert-That (@($types.code | Select-Object -Unique).Count -eq $types.Count) 'Duplicate type codes.'
    foreach ($type in $types) {
        Assert-That ((@($type.PSObject.Properties.Name | Sort-Object) -join ',') -eq 'code,establishment_type_category_id,name') 'Unexpected lookup properties.'
        Assert-That ($type.code -is [string] -and $type.code -cmatch '^[0-9]{2}$') 'Type codes must remain two-digit strings.'
        Assert-That ($type.establishment_type_category_id -is [int] -and $type.establishment_type_category_id -gt 0) 'Category ID must be a positive integer.'
    }
    foreach ($expected in @(@('01', 'Community school'), @('02', 'Voluntary aided school'), @('03', 'Voluntary controlled school'), @('05', 'Foundation school'))) {
        $type = @($types | Where-Object { $_.code -ceq $expected[0] })
        Assert-That ($type.Count -eq 1 -and $type[0].name -ceq $expected[1]) "Missing expected type $($expected[0])."
    }

    $all = @((Request '/v1/establishments?pageSize=10000').Json.items)
    $expected = @($all | Where-Object { $_.providerType.code -in @('01', '02', '03') })
    Assert-That (@($expected.providerType.code | Select-Object -Unique).Count -ge 2) 'Test data needs published establishments of at least two selected types.'
    Assert-That (@($expected | Where-Object { $_.establishmentStatus.code -eq '2' }).Count -gt 0) 'Test data needs a closed establishment of a selected type.'
    $filtered = (Request '/v1/establishments?establishmenttype=01,02,03&pageSize=10000').Json
    Assert-That (($filtered.items.urn -join ',') -ceq ($expected.urn -join ',')) 'OR filter differs from the union of selected types.'
    $openExpected = @($expected | Where-Object { $_.establishmentStatus.code -eq '1' })
    $open = (Request '/v1/establishments?establishmenttype=01,02,03&status=open&pageSize=10000').Json
    Assert-That (($open.items.urn -join ',') -ceq ($openExpected.urn -join ',')) 'Status and type filters must combine using AND.'
    $duplicates = (Request '/v1/establishments?establishmenttype=03,01,02,01&pageSize=10000').Json
    Assert-That (($duplicates.items.urn -join ',') -ceq ($expected.urn -join ',')) 'Duplicate or reordered codes changed the result.'

    $pagedUrns = @()
    $next = '/v1/establishments?establishmenttype=01,02,03&status=open&pageSize=1'
    $pages = 0
    while ($next) {
        $page = (Request $next).Json
        $pagedUrns += @($page.items.urn)
        Assert-That ($page.items.Count -le 1) 'pageSize not respected.'
        if ($page.next) {
            $decoded = [uri]::UnescapeDataString($page.next)
            Assert-That ($decoded.Contains('establishmenttype=01,02,03') -and $decoded.Contains('status=open')) 'Next link lost filters.'
        }
        $next = $page.next
        $pages++
        if ($pages -gt 100) { throw 'Pagination did not terminate.' }
    }
    Assert-That (($pagedUrns -join ',') -ceq ($openExpected.urn -join ',')) 'Filtering/pagination lost, duplicated or included unrelated records.'
    $pastEnd = (Request '/v1/establishments?establishmenttype=01,02,03&pageSize=1&page=10000').Json
    Assert-That ($pastEnd.items.Count -eq 0 -and -not $pastEnd.hasNextPage -and $null -eq $pastEnd.next) 'Past-final-page indicators incorrect.'
    if ('99' -notin $types.code) {
        $unknown = (Request '/v1/establishments?establishmenttype=99').Json
        Assert-That ($unknown.items.Count -eq 0) 'Unknown well-formed codes should match no establishments.'
    }
    foreach ($value in @('', '1', '001', '01,', ',01', '01,,02', '01,%2002', 'ab', '01%0A', '01%27%20OR%201=1')) {
        $errorResponse = Request ("/v1/establishments?establishmenttype=$value") 400
        Assert-That ($errorResponse.Json.code -eq 'invalid-establishmenttype-filter') 'Wrong type-filter error code.'
        Assert-That ($errorResponse.Json.errors[0].location -eq 'query' -and $errorResponse.Json.errors[0].name -eq 'establishmenttype') 'Missing query validation detail.'
    }
    $repeated = Request '/v1/establishments?establishmenttype=01&establishmenttype=02' 400
    Assert-That ($repeated.Json.code -eq 'invalid-establishmenttype-filter') 'Repeated filter parameter accepted.'
    $null = Request '/v1/establishment-types?status=open' 400
    $null = Request '/v1/establishment-types/' 404
    $null = Request '/v1/Establishment-types' 404
    $null = Request '/v1/establishment-types' 405 @{} 'POST'
    # Windows PowerShell's HttpClient rejects GET bodies before sending them.
    $bodyResponse = @(& curl.exe --silent --show-error --request GET --data-binary '{}' --write-out "`n%{http_code}" ($BaseUrl.TrimEnd('/') + '/v1/establishment-types')) -join "`n"
    Assert-That ($LASTEXITCODE -eq 0 -and $bodyResponse.EndsWith('400') -and $bodyResponse.Contains('unexpected-request-body')) 'GET body was not rejected.'
    $null = Request '/v1/establishment-types' 406 @{ Accept = 'text/plain' }
    $null = Request '/v1/establishment-types' 304 @{ 'If-None-Match' = $lookupResponse.ETag }
    $null = Request '/v1/establishments?establishmenttype=01' 304 @{ 'If-None-Match' = (Request '/v1/establishments?establishmenttype=01').ETag }
    $null = Request '/v1/establishments/100018'
    Write-Host "Passed $script:checks assertions across Swagger UI assets, OpenAPI references, lookup shape, OR/AND filters, pagination, validation, routing and conditional retrieval."
} finally { $client.Dispose() }
