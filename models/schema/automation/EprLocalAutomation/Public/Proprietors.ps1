function Import-ProprietorReviewQueue {
    param([Parameter(Mandatory)]$Target)
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'seed/seed-stage-4-proprietor-review.sql') -FailureMessage 'Proprietor review queue failed'
}
