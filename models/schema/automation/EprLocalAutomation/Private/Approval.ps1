# Comparing approval snapshots.

function ConvertTo-ApprovalText {
    # Normalises line endings, byte-order marks and surrounding space so that
    # snapshots compare the same on Windows and elsewhere.
    param([string]$Value)
    if ($null -eq $Value) { return '' }
    return $Value.TrimStart([char]0xFEFF).Replace("`r`n", "`n").Replace("`r", "`n").Trim()
}
