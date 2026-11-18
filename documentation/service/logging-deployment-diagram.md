# Education Provider Registry: logging deployment view

This view shows only components involved in log collection and delivery from the [main deployment diagram](../deployment-diagram.md). It omits request handling, data feeds, secrets and replication relationships.

```mermaid
%%{init: {"wrap": true, "c4": {"width": 260}}}%%
C4Deployment
    title EPR public beta - logging view

    UpdateLayoutConfig($c4ShapeInRow="5", $c4BoundaryInRow="2")

    System_Ext(logit, "logit.io", "Shared TSC log stacks")

    Boundary(sub, "EPR environment subscription", "S189 test or production; see environment table") {

        Deployment_Node(vnet, "S189 environment VNet", "Azure virtual network") {
            Deployment_Node(aks, "Teacher Services Cloud AKS cluster", "Shared with other TSC services") {
                Deployment_Node(platform, "Shared TSC platform services", "Platform-managed components") {
                    Container(filebeat, "Platform Filebeat", "TSC-managed DaemonSet", "Reads annotated pods' log files on AKS nodes")
                    Container(ingress, "Shared ingress controller", "nginx / Traefik", "Container logs collected by Filebeat")

                }
                Deployment_Node(apps, "EPR application workloads", "Kubernetes namespace: gias-production") {
                    Container(web, "Website", "ASP.NET Core", "Writes logs to stdout/stderr")
                    Container(api, "Public API", "ASP.NET Core", "Writes logs to stdout/stderr")
                }
            }

            ContainerDb(readSrv, "Read server", "PostgreSQL Flexible Server", "Server diagnostics when monitoring is enabled")
            ContainerDb(txSrv, "Transactional server", "PostgreSQL Flexible Server", "Server diagnostics when monitoring is enabled")
        }

        Deployment_Node(afd, "Azure Front Door", "Global edge service") {
            Container(webEp, "Website endpoint", "[service-domain]", "Access and WAF diagnostics")
            Container(apiEp, "API endpoint", "api.[service-domain]", "Access and WAF diagnostics")
        }


        Container(adf, "Data Factory", "Azure Data Factory", "BAU feed pipeline, activity and trigger logs<br/>Design decision; implementation pending")
        Container(law, "Log Analytics", "Azure Monitor workspaces", "Front Door, PostgreSQL and Data Factory diagnostics<br/>Logical grouping; separate workspaces may apply")
    }

    Rel(web, filebeat, "Container stdout/stderr collected")
    Rel(api, filebeat, "Container stdout/stderr collected")
    Rel(ingress, filebeat, "Ingress container logs collected")
    Rel(filebeat, logit, "Ships collected logs", "TLS")

    Rel(webEp, law, "Front Door profile access and WAF diagnostics", "TLS 1.2")
    Rel(apiEp, law, "Same profile: API access and WAF diagnostics", "TLS 1.2")
    Rel(readSrv, law, "Server diagnostics, when monitoring enabled", "TLS 1.2")
    Rel(txSrv, law, "Server diagnostics, when monitoring enabled", "TLS 1.2")
    Rel(adf, law, "Pipeline, activity and trigger diagnostics (design)", "TLS 1.2")

    %% Edge endpoints: amber
    UpdateElementStyle(webEp, $bgColor="#fef3c7", $fontColor="#78350f", $borderColor="#d97706")
    UpdateElementStyle(apiEp, $bgColor="#fef3c7", $fontColor="#78350f", $borderColor="#d97706")

    %% Application and integration workloads: green
    UpdateElementStyle(web, $bgColor="#e9f6ef", $fontColor="#18324b", $borderColor="#26775e")
    UpdateElementStyle(api, $bgColor="#e9f6ef", $fontColor="#18324b", $borderColor="#26775e")
    UpdateElementStyle(adf, $bgColor="#e9f6ef", $fontColor="#18324b", $borderColor="#26775e")

    %% Shared platform services: teal
    UpdateElementStyle(ingress, $bgColor="#ccfbf1", $fontColor="#134e4a", $borderColor="#0f766e")
    UpdateElementStyle(filebeat, $bgColor="#ccfbf1", $fontColor="#134e4a", $borderColor="#0f766e")

    %% Database servers: blue
    UpdateElementStyle(readSrv, $bgColor="#dbeafe", $fontColor="#172554", $borderColor="#2563eb")
    UpdateElementStyle(txSrv, $bgColor="#dbeafe", $fontColor="#172554", $borderColor="#2563eb")

    %% Log destinations: purple
    UpdateElementStyle(law, $bgColor="#ede9fe", $fontColor="#3b0764", $borderColor="#7c3aed")
    UpdateElementStyle(logit, $bgColor="#ede9fe", $fontColor="#3b0764", $borderColor="#7c3aed")
    UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="2")
```

## Logging configuration
The support columns map the logging design to the supplied security documents. They describe contributions to controls, rather than completed assessments or proof of deployed operation. 

| Component | Ownership | Logging / collection | Destination and transport | Configuration and status | Baseline support | OWASP support |
| --- | --- | --- | --- | --- | --- | --- |
| Website | EPR | Writes application logs to stdout/stderr; Filebeat collects the resulting container log files. | Platform Filebeat → logit.io over TLS. | Set `enable_logit = true` on the shared application module to add `logit.io/send: "true"` to pods. EPR must agree event fields, JSON formatting, log levels and sensitive-data filtering. | 3.8, 3.10; 8.1, 8.2 | A09: event collection and format (partial); A04: log transport |
| Public API | EPR | Writes application logs to stdout/stderr; Filebeat collects the resulting container log files. | Platform Filebeat → logit.io over TLS. | Set `enable_logit = true` on the shared application module. EPR must agree API event fields, correlation and consumer identifiers, log levels and sensitive-data filtering. | 3.8, 3.10; 8.1, 8.2 | A09: event collection and format (partial); A04: log transport |
| Shared ingress controller | TSC | Emits ingress container logs collected by Filebeat. | Platform Filebeat → logit.io over TLS. | TSC manages the nginx / Traefik deployment and Logit pod annotation.  | 3.8, 3.10; 8.1, 8.2 | A09: request-log collection (partial); A04: log transport |
| Platform Filebeat | TSC | Runs as a DaemonSet and reads annotated pods' log files on AKS nodes; collection does not call the applications. | Shared TSC logit.io stack over TLS. | TSC manages pod discovery, the `BEATS-URL` destination secret and `ssl.enabled: true`.| 3.8, 3.10; 8.1, 8.2 | A09: off-node collection (partial); A04: log transport |
| Front Door website endpoint | EPR | Front Door profile access and WAF diagnostics covering website traffic. | Log Analytics over TLS 1.2. | Enable `azure_enable_monitoring` on the shared domains infrastructure module. Settings apply to the Front Door profile.  | 3.8, 3.10; 8.1, 8.2 | A09: access/WAF event collection (partial); A04: log transport |
| Front Door API endpoint | EPR | Front Door profile access and WAF diagnostics covering API traffic. | Log Analytics over TLS 1.2. | Covered by the same profile-level diagnostic settings as the website endpoint| 3.8, 3.10; 8.1, 8.2 | A09: access/WAF event collection (partial); A04: log transport |
| Read PostgreSQL server | EPR | Server diagnostic logs; audit events require separate PostgreSQL audit configuration. | Log Analytics over TLS 1.2. | Enable `azure_enable_monitoring` on the PostgreSQL module. Database contents are not automatically copied into logs. | 3.8, 3.10; 8.1, 8.2; 3.14/8.5 conditional on audit configuration | A09: server-log collection (partial); audit trail conditional; A04: log transport |
| Transactional PostgreSQL server | EPR | Server diagnostics for the server hosting establishment and governance databases; audit events require separate configuration. | Log Analytics over TLS 1.2. | Enable `azure_enable_monitoring` on the PostgreSQL module. | 3.8, 3.10; 8.1, 8.2; 3.14/8.5 conditional on audit configuration | A09: server-log collection (partial); audit trail conditional; A04: log transport |
| Data Factory — EPR BAU feed | EPR | Pipeline, activity and trigger run logs: `PipelineRuns`, `ActivityRuns`, `TriggerRuns`. | Environment Log Analytics workspace over TLS 1.2. | `azure_enable_monitoring = true` enables module metric alerts. Configure a separate diagnostic setting to send `PipelineRuns`, `ActivityRuns` and `TriggerRuns` to an environment Log Analytics workspace using resource-specific tables: `ADFPipelineRun`, `ADFActivityRun` and `ADFTriggerRun`. | 3.8, 3.10; 8.1, 8.2 (target design) | A09: run-log collection (partial); A04: log transport |
| Log Analytics | EPR | Receives Azure diagnostic logs from Front Door, PostgreSQL and, by design, Data Factory. | Azure Monitor workspaces; no onward forwarding to logit.io is established. | The diagram groups destinations logically; modules may create separate workspaces. ADF can reuse a suitable workspace where access and retention requirements align. [Azure Monitor documents TLS 1.2 support for diagnostic destinations](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/diagnostic-settings#destinations). | 3.8, 3.10; 8.1, 8.2; 8.9 aggregation only | A09: central collection (partial); A04: log transport |
| logit.io | TSC | Receives application and ingress logs shipped by platform Filebeat. | Shared TSC log stacks outside the EPR subscription. | TSC manages the environment stacks and shipping infrastructure. Security Information and Event Management (SIEM) forwarding is a separate integration. | 3.8, 3.10; 8.1, 8.2; 8.9 aggregation only | A09: central collection (partial); A04: log transport |
