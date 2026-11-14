function Start-DevelopmentSeedRun {
    param([Parameter(Mandatory)]$Source,[Parameter(Mandatory)]$Target)
    $database=$Source.Database.Replace("'","''")
    return [guid](Invoke-Psql -Target $Target -Output Scalar -FailureMessage 'Development run creation failed' -Command "INSERT INTO migration.migration_run(run_type,source_system,source_database,status,transform_version) VALUES('development-establishment-seed','GIAS BAU','$database','running','dev-seed-v2') RETURNING migration_run_id;")
}

function Complete-DevelopmentSeedRun {
    param([Parameter(Mandatory)]$Target,[Parameter(Mandatory)][guid]$MigrationRunId,[switch]$Failed)
    $status=if ($Failed) {"'failed'"} else {@"
CASE WHEN EXISTS(SELECT 1 FROM migration.establishment_load_error WHERE migration_run_id='$MigrationRunId')
       OR EXISTS(SELECT 1 FROM migration.relationship_load_error WHERE migration_run_id='$MigrationRunId')
     THEN 'completed_with_errors' ELSE 'completed' END
"@}
    Invoke-Psql -Target $Target -Quiet -FailureMessage 'Development run completion failed' -Command "UPDATE migration.migration_run SET status=$status,completed_at=clock_timestamp() WHERE migration_run_id='$MigrationRunId';"
    if (-not $Failed) {
        Invoke-Psql -Target $Target -FailureMessage 'Development run summary failed' -Command "SELECT status FROM migration.migration_run WHERE migration_run_id='$MigrationRunId'; SELECT phase.key AS phase,phase.value AS outcome FROM migration.migration_run r CROSS JOIN LATERAL jsonb_each(r.notes::jsonb) phase WHERE r.migration_run_id='$MigrationRunId' AND phase.key IN ('party','organisation_groups','sen','maintenance') ORDER BY phase.key; SELECT relationship_kind,count(*) AS rejected_entries FROM migration.relationship_load_error WHERE migration_run_id='$MigrationRunId' GROUP BY relationship_kind ORDER BY relationship_kind;"
    }
}
