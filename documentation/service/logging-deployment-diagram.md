# Logging deployment view

This view shows only components involved in log collection and delivery from the [main deployment diagram](../deployment-diagram.md). It omits request handling, data feeds, secrets and replication relationships.

## Deployment diagram

### Key

```mermaid
%%{init: {"wrap": true, "c4": {"width": 180}}}%%
C4Deployment
    Container(key_workloads, "EPR workloads", "")
    Container(key_collection, "Platform log collection", "")
    Container(key_databases, "Database servers", "")
    Container(key_destinations, "Log destinations", "")
    Container(key_edge, "Front Door endpoints", "")

    UpdateElementStyle(key_workloads, $bgColor="#e9f6ef", $fontColor="#18324b", $borderColor="#26775e")
    UpdateElementStyle(key_collection, $bgColor="#ccfbf1", $fontColor="#134e4a", $borderColor="#0f766e")
    UpdateElementStyle(key_databases, $bgColor="#dbeafe", $fontColor="#172554", $borderColor="#2563eb")
    UpdateElementStyle(key_destinations, $bgColor="#ede9fe", $fontColor="#3b0764", $borderColor="#7c3aed")
    UpdateElementStyle(key_edge, $bgColor="#fef3c7", $fontColor="#78350f", $borderColor="#d97706")
    UpdateLayoutConfig($c4ShapeInRow="5", $c4BoundaryInRow="1")
```
### Logging view
```mermaid
%%{init: {"wrap": true, "c4": {"width": 360}}}%%
C4Deployment

    UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="2")

    System_Ext(logit, "logit.io", "Shared Teacher Services Cloud log stacks")

    Boundary(sub, "EPR environment subscription", "S189 test or production; see environment table") {

        Deployment_Node(vnet, "S189 environment VNet", "Azure virtual network") {
            Deployment_Node(aks, "Teacher Services Cloud AKS cluster", "Shared with other Teacher Services Cloud services") {
                Deployment_Node(platform, "Shared Teacher Services Cloud platform services", "Platform-managed components") {
                    Container(filebeat, "Platform Filebeat", "Teacher Services Cloud-managed DaemonSet", "Reads annotated pods' log files on AKS nodes")
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

    Rel(web, filebeat, "stdout/stderr<br/>collection")
    Rel(api, filebeat, "stdout/stderr<br/>collection")
    Rel(ingress, filebeat, "Ingress log<br/>collection")
    Rel(filebeat, logit, "Collected logs", "TLS")

    Rel(webEp, law, "Access and WAF<br/>diagnostics", "TLS 1.2")
    Rel(apiEp, law, "API access and WAF<br/>(same profile)", "TLS 1.2")
    Rel(readSrv, law, "Server diagnostics<br/>(when enabled)", "TLS 1.2")
    Rel(txSrv, law, "Server diagnostics<br/>(when enabled)", "TLS 1.2")
    Rel(adf, law, "Pipeline, activity<br/>and trigger logs (design)", "TLS 1.2")

    %% Separate collection labels around Filebeat.
    UpdateRelStyle(web, filebeat, $offsetX="0", $offsetY="-30")
    UpdateRelStyle(api, filebeat, $offsetX="50", $offsetY="0")
    UpdateRelStyle(ingress, filebeat, $offsetX="10", $offsetY="20")
    UpdateRelStyle(filebeat, logit, $offsetX="90", $offsetY="430")

    %% Stagger labels on the diagnostic paths into Log Analytics.
    UpdateRelStyle(webEp, law, $offsetX="200", $offsetY="60")
    UpdateRelStyle(apiEp, law, $offsetX="250", $offsetY="140")
    UpdateRelStyle(readSrv, law, $offsetX="-60", $offsetY="60")
    UpdateRelStyle(txSrv, law, $offsetX="20", $offsetY="60")
    UpdateRelStyle(adf, law, $offsetX="-50", $offsetY="-85")

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

```

## Logging configuration
The **Baseline security support** and **OWASP support** columns map the design to the supplied security documents. They describe contributions to controls, rather than completed assessments or proof of deployed operation. A blank cell means no direct support is established by that row. Baseline references are safeguard numbers; OWASP references are categories in the supplied 2025 controls list. The [application metrics and alerting view](application-metrics-and-alerting-deployment-diagram.md) uses the same convention.

| Component | Ownership | Logging / collection | Destination and transport | Configuration and status | Baseline security support | OWASP support |
| --- | --- | --- | --- | --- | --- | --- |
| Website | EPR | Writes application logs to stdout/stderr; Filebeat collects the resulting container log files. | Platform Filebeat → logit.io over TLS. | Set `enable_logit = true` on the shared application module to add `logit.io/send: "true"` to pods. EPR must agree event fields, JSON formatting, log levels and sensitive-data filtering. | 3.8, 3.10; 8.1, 8.2 | A09: event collection and format; A04: log transport |
| Public API | EPR | Writes application logs to stdout/stderr; Filebeat collects the resulting container log files. | Platform Filebeat → logit.io over TLS. | Set `enable_logit = true` on the shared application module. EPR must agree API event fields, correlation and consumer identifiers, log levels and sensitive-data filtering. | 3.8, 3.10; 8.1, 8.2 | A09: event collection and format; A04: log transport |
| Shared ingress controller | Teacher Services Cloud | Emits ingress container logs collected by Filebeat. | Platform Filebeat → logit.io over TLS. | Teacher Services Cloud manages the nginx / Traefik deployment and Logit pod annotation.  | 3.8, 3.10; 8.1, 8.2 | A09: request-log collection; A04: log transport |
| Platform Filebeat | Teacher Services Cloud | Runs as a DaemonSet and reads annotated pods' log files on AKS nodes; collection does not call the applications. | Shared Teacher Services Cloud logit.io stack over TLS. | Teacher Services Cloud manages pod discovery, the `BEATS-URL` destination secret and `ssl.enabled: true`.| 3.8, 3.10; 8.1, 8.2 | A09: off-node collection; A04: log transport |
| Front Door website endpoint | EPR | Front Door profile access and WAF diagnostics covering website traffic. | Log Analytics over TLS 1.2. | Enable `azure_enable_monitoring` on the shared domains infrastructure module. Settings apply to the Front Door profile.  | 3.8, 3.10; 8.1, 8.2 | A09: access/WAF event collection; A04: log transport |
| Front Door API endpoint | EPR | Front Door profile access and WAF diagnostics covering API traffic. | Log Analytics over TLS 1.2. | Covered by the same profile-level diagnostic settings as the website endpoint| 3.8, 3.10; 8.1, 8.2 | A09: access/WAF event collection; A04: log transport |
| Read PostgreSQL server | EPR | Server diagnostic logs; audit events require separate PostgreSQL audit configuration. | Log Analytics over TLS 1.2. | Enable `azure_enable_monitoring` on the PostgreSQL module. Database contents are not automatically copied into logs. | 3.8, 3.10; 8.1, 8.2; 3.14/8.5 conditional on audit configuration | A09: server-log collection; audit trail conditional; A04: log transport |
| Transactional PostgreSQL server | EPR | Server diagnostics for the server hosting establishment and governance databases; audit events require separate configuration. | Log Analytics over TLS 1.2. | Enable `azure_enable_monitoring` on the PostgreSQL module. | 3.8, 3.10; 8.1, 8.2; 3.14/8.5 conditional on audit configuration | A09: server-log collection; audit trail conditional; A04: log transport |
| Data Factory — EPR BAU feed | EPR | Pipeline, activity and trigger run logs: `PipelineRuns`, `ActivityRuns`, `TriggerRuns`. | Environment Log Analytics workspace over TLS 1.2. | `azure_enable_monitoring = true` enables module metric alerts. Configure a separate diagnostic setting to send `PipelineRuns`, `ActivityRuns` and `TriggerRuns` to an environment Log Analytics workspace using resource-specific tables: `ADFPipelineRun`, `ADFActivityRun` and `ADFTriggerRun`. | 3.8, 3.10; 8.1, 8.2 (target design) | A09: run-log collection; A04: log transport |
| Log Analytics | EPR | Receives Azure diagnostic logs from Front Door, PostgreSQL and, by design, Data Factory. | Azure Monitor workspaces; no onward forwarding to logit.io is established. | The diagram groups destinations logically; modules may create separate workspaces. ADF can reuse a suitable workspace where access and retention requirements align. [Azure Monitor documents TLS 1.2 support for diagnostic destinations](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/diagnostic-settings#destinations). | 3.8, 3.10; 8.1, 8.2; 8.9 aggregation only | A09: central collection; A04: log transport |
| logit.io | Teacher Services Cloud | Receives application and ingress logs shipped by platform Filebeat. | Shared Teacher Services Cloud log stacks outside the EPR subscription. | Teacher Services Cloud manages the environment stacks and shipping infrastructure. Security Information and Event Management (SIEM) forwarding is a separate integration. | 3.8, 3.10; 8.1, 8.2; 8.9 aggregation only | A09: central collection; A04: log transport |
