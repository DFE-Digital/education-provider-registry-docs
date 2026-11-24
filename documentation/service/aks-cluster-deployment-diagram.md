# Inside the AKS cluster

This view supplements the [deployment overview](deployment-diagram.md). See its [environment information](deployment-diagram.md#environment-information) for namespace selection.

What runs in our namespace, what the platform runs for us, and where the boundaries are. The red arrow is a route that must not exist.

```mermaid
%%{init: {"wrap": true, "c4": {"width": 260}}}%%
C4Deployment
    title Inside the TSC AKS cluster - EPR namespace and the shared platform

    System_Ext(afd, "Azure Front Door", "Adds X-Azure-FDID and X-Azure-SocketIP")
    System_Ext(direct, "Direct caller", "Skips Front Door")

    Deployment_Node(aks, "TSC AKS cluster", "Shared. Nodes patched by the TSC platform.") {
        Deployment_Node(platform, "Platform namespaces", "Run by the TSC team") {
            Container(ingressCtl, "Ingress controller", "nginx today", "TLS 1.2 and 1.3<br/>50 MB bodies, 120 s timeouts<br/>Can't check our Front Door ID")
        }
        Deployment_Node(ns, "EPR application workloads", "Kubernetes namespace: gias-production") {
            Container(ingWeb, "Website ingress", "Kubernetes Ingress", "[web-origin].teacherservices.cloud")
            Container(web, "Website pods", "Deployment, 2+ replicas, PDB", "Non-root, read-only root filesystem<br/>No service account token<br/>Front Door ID check first<br/>Health path exempt")
            Container(ingApi, "API ingress", "Kubernetes Ingress", "[api-origin].teacherservices.cloud")
            Container(api, "API pods", "Deployment, 2+ replicas, PDB", "As the website<br/>Key check per ADR 0005<br/>Per-consumer limit (O2)")
        }
    }

    Deployment_Node(dbnet, "Database subnets", "Delegated, private DNS") {
        ContainerDb(read, "Read server", "PostgreSQL", "epr_web_reader<br/>epr_api_reader")
        ContainerDb(tx, "Transactional server", "PostgreSQL", "Unpublished data")
    }

    Rel(afd, ingressCtl, "HTTPS")
    Rel(direct, ingressCtl, "HTTPS to the default hostname")
    Rel(ingressCtl, ingWeb, "Routes by host")
    Rel(ingressCtl, ingApi, "Routes by host")
    Rel(ingWeb, web, "HTTP, port 8080")
    Rel(ingApi, api, "HTTP")
    Rel(web, read, "TLS verify-full")
    Rel(api, read, "TLS verify-full")
    Rel(web, tx, "Must fail (transactional database network isolation, O11)")

    UpdateRelStyle(direct, ingressCtl, $textColor="#b91c1c", $lineColor="#b91c1c")
    UpdateRelStyle(web, tx, $textColor="#b91c1c", $lineColor="#b91c1c")
    UpdateElementStyle(direct, $bgColor="#fee2e2", $fontColor="#7f1d1d", $borderColor="#b91c1c")
    UpdateElementStyle(web, $bgColor="#e9f6ef", $fontColor="#18324b", $borderColor="#26775e")
    UpdateElementStyle(api, $bgColor="#eaf2fb", $fontColor="#18324b", $borderColor="#2165a5")
    UpdateLayoutConfig($c4ShapeInRow="2", $c4BoundaryInRow="2")
```

A direct caller can reach the ingress controller, because the default `teacherservices.cloud` hostnames are public. The ingress passes the request on. Our pods then refuse it with a 403, because it has no Front Door ID (Front Door origin validation). This is risk IR-01. See [Shared ingress risks](deployment-diagram.md#shared-ingress-risks).

