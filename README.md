# azure-platform-lab
Hands-on Azure platform engineering lab: Terraform, Azure DevOps, AKS, Key Vault, DevSecOps

## What it builds
<!-- Check each layer on the Sunday it's working. -->
- [x] **Nov 15** – App Service deployed with Terraform (variables, outputs, required tags)
- [ ] **Nov 22** – Remote state in Azure Storage · Key Vault + managed identity (no secrets in code) · Azure DevOps pipeline · Docker container on local Kubernetes
- [ ] **Dec 6** – Storage account (TLS 1.2, no public access)
- [ ] **Dec 13** – Container registry · VNet integration + Key Vault private endpoint + private DNS
- [ ] **Dec 20** – Log Analytics + Application Insights
- [ ] **Dec 27** – Terraform modules + dev/prod environments · app build/deploy stages with smoke test
- [ ] **Jan 3** – AKS with Helm, ingress, autoscaling, Key Vault CSI secrets
- [ ] **Jan 10** – DevSecOps: Checkov, Trivy, Bandit, SonarCloud, ZAP, Dependabot, threat model
- [ ] **Jan 31** – API Management, New Relic, cost review, Bicep, Ansible

## Security
- Governance: Azure Policy requires an `owner` tag on every resource group

## Tools
Terraform · Azure DevOps · PowerShell · Bash · Python · Docker · Kubernetes · Helm · Bicep · Ansible · New Relic

## How to deploy
1. `az login`
2. `export TF_VAR_subscription_id=$(az account show --query id -o tsv)`
3. `cd terraform && terraform init && terraform plan`
4. `terraform apply` (from Nov 19: open a PR → pipeline runs Validate/Plan → merge → approve → Apply)

## What I learned
- **Week 1 (Nov 15):** Terraform works in a cycle: `init` → `plan` → `apply` → `destroy`, and `plan` lets me preview every change before it happens. When I changed a tag in the portal, `plan` caught the drift and `apply` put it back to match the code. Keeping the subscription ID in a `TF_VAR_` environment variable keeps it out of GitHub, and Azure Policy can block resources that are missing required tags.
- **Week 2 (Nov 22):** ___
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
- Remote state, Key Vault with managed identity, and an Azure DevOps pipeline (Week 2)
