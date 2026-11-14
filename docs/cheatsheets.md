# Cheat Sheet – Azure Platform Lab


### Week 1 (Nov 9-15)

#### Mon, Nov 9

- `git clone` = downloads a copy of a GitHub repo to my computer, including its full history
- `git status` = shows which files changed, which are staged, and which branch I'm on
- `git add .` = stages all changed files so they're included in the next commit
- `git commit -m` = saves a snapshot of the staged changes locally, with a message describing what changed
- `git push` = uploads my local commits to GitHub
- `.gitignore` excludes `.terraform/`, `*.tfstate`, `*.tfvars`, `.env`, keys, `.DS_Store` because they can contain secrets or are local/generated files that don't belong in Git

#### Tue, Nov 10

- F8 = runs the selected line(s) in the terminal | F5 = runs the whole script | Cmd+Shift+P = Command Palette (search any VS Code command)
- `pwsh` vs Windows PowerShell 5.1: pwsh = PowerShell 7, cross-platform (Mac/Linux/Windows), still updated; 5.1 = Windows-only, no new features
- Az cmdlet pattern `Verb-AzNoun`, example: `New-AzResourceGroup` (Verb = action like Get/New/Set/Remove, Az = Azure module, Noun = resource)
- `Connect-AzAccount` = signs in to Azure | `Get-AzContext` = shows which account, tenant, and subscription I'm using

#### Wed, Nov 11

- Policy definition vs assignment: definition = the rule (what to check); assignment = applying that rule to a scope
- Effects: Deny = blocks non-compliant resources from being created, Audit = allows them but flags them as non-compliant
- Scope order: Management group > Subscription > Resource group > Resource
- `#!/bin/bash` = shebang; tells the system to run the script with Bash
- `set -euo pipefail` = stop on any error (-e), error on undefined variables (-u), fail if any command in a pipe fails (pipefail)
- `chmod +x` = makes a file executable so it can run as `./script.sh`
- `--query "[].name" -o tsv` = JMESPath filter that pulls only the name field from each result; `-o tsv` outputs plain text with no quotes or JSON

#### Thu, Nov 12

- 3 reasons for IaC: repeatable (same result every time), version-controlled (reviewed in PRs, history in Git), no drift/manual mistakes (code is the source of truth)
- `init` = downloads providers and sets up the backend | `fmt` = auto-formats code to standard style | `validate` = checks syntax and config are valid
- `plan` = previews what will be created, changed, or destroyed | `apply` = makes the changes in Azure | `destroy` = deletes everything Terraform manages
- Provider = plugin that lets Terraform talk to a platform's API (e.g., azurerm for Azure)
- `.terraform.lock.hcl` = locks the exact provider versions so everyone gets the same ones (commit it? yes)

#### Fri, Nov 13

- Block / argument = block is a container like `resource "type" "name" { }`; argument is a setting inside it like `name = "rg-gglab"`
- Resource vs data source: resource = something Terraform creates and manages; data source = reads info about something that already exists (read-only)
- `azurerm_resource_group.rg.name` means: resource type `azurerm_resource_group`, my local name `rg`, attribute `name`
- Implicit dependency = when one resource references another, Terraform automatically creates the referenced one first (e.g., resource group before the App Service plan)

#### Sat, Nov 14

- Variable (type, default) = input to my config; `type` sets what kind of value (string, number, bool, list, map), `default` is used if no other value is given
- `TF_VAR_name` = environment variable that sets a Terraform variable (e.g., `TF_VAR_subscription_id` sets `var.subscription_id`); keeps IDs out of my code
- Variable precedence (lowest → highest): default → `TF_VAR_` env var → `terraform.tfvars` → `*.auto.tfvars` → `-var` / `-var-file` on the command line
- Output = value Terraform prints after apply and saves in state | `terraform output -raw x` = prints just that output's value with no quotes (good for scripts)
- Why `random_integer` in names: App Service names must be globally unique across all of Azure, so a random number avoids name conflicts
- F1 vs B1 plan: F1 = free, shared, no always-on, no VNet integration; B1 = paid (hourly), dedicated, supports always-on and VNet integration

#### Sun, Nov 15

- **Drift** = a change made outside Terraform (e.g., in the portal), so Azure no longer matches the code ; how `plan` shows it: `~` update in-place with old value `->` new value; `apply` puts it back to match the code
- Python: types I used `int`, `float`, `str`, `bool` | f-string example `print(f"Hello {name}, you have {count} resources")`
- Python: `if` / `while` example `if count > 0: print("found")` / `while count < 5: count = count + 1`