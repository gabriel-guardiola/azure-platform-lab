# azure-platform-lab
Hands-on Azure platform engineering lab: Terraform, Azure DevOps, AKS, Key Vault, DevSecOps

## What it builds
<!-- Check each layer on the Sunday it's working. -->
- [x] **Nov 15** – App Service deployed with Terraform (variables, outputs, required tags)
- [x] **Nov 22** – Remote state in Azure Storage · Key Vault + managed identity (no secrets in code) · Azure DevOps pipeline · Docker container on local Kubernetes
- [ ] **Dec 6** – Storage account (TLS 1.2, no public access)
- [ ] **Dec 13** – Container registry · VNet integration + Key Vault private endpoint + private DNS
- [ ] **Dec 20** – Log Analytics + Application Insights
- [ ] **Dec 27** – Terraform modules + dev/prod environments · app build/deploy stages with smoke test
- [ ] **Jan 3** – AKS with Helm, ingress, autoscaling, Key Vault CSI secrets
- [ ] **Jan 10** – DevSecOps: Checkov, Trivy, Bandit, SonarCloud, ZAP, Dependabot, threat model
- [ ] **Jan 31** – API Management, New Relic, cost review, Bicep, Ansible

## Security
- **Governance:** Azure Policy requires an `owner` tag on every resource group
- **Containers:** app runs as a non-root user
- **Secrets:** Key Vault (RBAC mode); app reads secrets via a Key Vault reference
- **Identity:** App Service managed identity with read-only Key Vault Secrets User; pipeline uses workload identity federation

## Pipeline
- **Nov 22:** Validate → Plan → Approval → Apply. PRs run Validate + Plan; Apply runs only after merge to `main` and manual approval. Signs in with workload identity federation (no stored secret).

## Tools
Terraform · Azure DevOps · PowerShell · Bash · Python · Docker · Kubernetes · Helm · Bicep · Ansible · New Relic

## How to deploy
1. Create a branch and make changes
2. Open a PR → pipeline runs Validate + Plan
3. Merge to `main` → approve the Apply stage in Azure DevOps
4. Locally: `terraform plan` only (apply runs in the pipeline)

**Run the app locally:**
- Docker: `docker build -t hello-api:v1 app/` → `docker run --rm -p 8080:8080 hello-api:v1`
- Kubernetes: `kubectl apply -f k8s/` → `kubectl port-forward svc/hello 8080:80`

## What I learned
- **Week 1 (Nov 15):** Terraform works in a cycle: `init` → `plan` → `apply` → `destroy`, and `plan` lets me preview every change before it happens. When I changed a tag in the portal, `plan` caught the drift and `apply` put it back to match the code. Keeping the subscription ID in a `TF_VAR_` environment variable keeps it out of GitHub, and Azure Policy can block resources that are missing required tags.

- **Week 2 (Nov 22):** Remote state lets the pipeline and me share the same state safely. A managed identity lets the app read Key Vault with no password anywhere, but new role assignments take minutes to take effect and App Service caches the result. My pipeline runs Plan on every PR and Apply only after merge and approval. Docker packages the app into an image, and Kubernetes keeps the right number of copies running and replaces any that fail.
- **Week 3 (Nov 29):** ___
- **Week 4 (Dec 6):** ___
- **Week 5 (Dec 13):** ___
- **Week 6 (Dec 20):** ___
- **Week 7 (Dec 27):** ___
- **Week 8 (Jan 3):** ___
- **Week 9 (Jan 10):** ___
- **Week 10 (Jan 17):** ___
- **Phase 4 (Jan 31):** ___

## Write-ups 
    # Some are unavailable at this time, template set up as a plan. 
[Migration plan](docs/migration-plan.md) · [Zero trust](docs/zero-trust.md) · [Threat model](docs/threat-model.md) · [Cost review](docs/cost-review.md) · [Monitoring](docs/monitoring.md) · [KQL](docs/kql.md) · [Errors log](docs/errors-log.md)                                           

## Certifications
- [ ] AZ-900 – target Nov 30
- [ ] AZ-104 – target Dec 19–20
- [ ] HashiCorp Terraform Associate (004) – target Jan 16–17
- [ ] AZ-400 – target spring

## Next steps
- AZ-900 (Nov 30) 