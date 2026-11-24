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


## Week 2 (Nov 16-20)

#### Mon, Nov 16

- State file stores = Terraform's record of every resource it manages (IDs, attributes, and sometimes secret values), used to compare code vs. what exists in Azure
- Why remote state: shared (a team or pipeline uses the same state), locked (prevents two applies at once), safe (not on a laptop; versioned so old copies can be recovered)
- Why state never goes in Git: it can contain secrets in plain text (e.g., my generated DbPassword) and resource details
- State locking = Azure Storage puts a lease (lock) on the state blob during plan/apply so two runs can't change it at the same time | `-migrate-state` = moves existing local state into the new backend during `init`
- `git checkout -b` = creates a new branch and switches to it | `push -u` = pushes the branch to GitHub and sets it to track the remote, so later `git push` works without extra arguments
- Pull request = request to merge my branch into `main`; shows the diff, allows review, runs checks, then merge
- My 4-step branch workflow: 1) `git checkout -b feature/x` 2) commit changes 3) `git push -u origin feature/x` and open a PR 4) merge, delete branch, then `git checkout main` + `git pull`
- Parallel job = capacity to run one pipeline job at a time; Microsoft-hosted free tier = 1 job, 1,800 min/month, 60 min per run; self-hosted = 1 free job on an agent I run myself
- Verified the hosted agent with a test pipeline (`pipelines/test.yml`); first run asks to authorize the GitHub connection
- Pipeline log: Pipelines > pipeline > run > job > click a step

#### Tue, Nov 17

- Key Vault RBAC mode vs access policies: RBAC = access controlled with Azure roles (same as other resources, works with IAM); access policies = older per-vault permission list that ignores Azure roles
- Secrets Officer = can create, read, update, and delete secrets (me / the pipeline) | Secrets User = can only read secret values (the web app)
- System vs user-assigned identity: system-assigned = created with the resource and deleted with it (1 per resource); user-assigned = standalone identity that can be shared by multiple resources and outlives them
- Key Vault reference: `@Microsoft.KeyVault(SecretUri=<secret versionless ID>)` = the app setting points to the secret; App Service fetches the value at runtime using the managed identity
- Soft delete = deleted vaults/secrets are kept recoverable for a retention period (7 days in my lab) and the name stays reserved | Purge = permanently deletes a soft-deleted item so the name can be reused
- Why a 403 right after a role assignment: new role assignments take several minutes to take effect
- Key Vault reference results are cached: after the role is active, restart the app (or change an app setting) so it checks again
- `depends_on` = explicit dependency for when Terraform can't detect one from references (the secret must wait for my role assignment)
- Data source example: `data "azurerm_client_config" "current"` = reads my tenant ID and object ID without creating anything
- PowerShell vs zsh: `export VAR=$(cmd)` is Bash/zsh only; in pwsh use `$env:VAR = (cmd)`; `$PID` is a reserved pwsh variable, don't use it as a name
- Why destroy after each session: avoid hourly charges and prove the lab rebuilds from code; never destroy `rg-tfstate`

#### Wed, Nov 18

- YAML indentation rule: spaces only (no tabs), consistent indentation (2 spaces); indentation shows what belongs to what
- List syntax `- item` | key/value syntax `key: value` | `|` = multi-line string that keeps line breaks (used for inline scripts)
- Pipeline hierarchy: trigger > pool > stages > jobs > steps (a stage holds jobs, a job holds steps, steps are tasks or scripts)
- Stage = major phase (e.g., Validate, Plan, Apply) | Job = runs on one agent | Step = a single task or script
- Service connection = saved, secure link from Azure DevOps to Azure that pipelines use to sign in and deploy
- Workload identity federation vs client secret: federation = Azure DevOps gets a short-lived token at run time, nothing stored that can leak or expire; client secret = a stored password that must be rotated and can be stolen
- Contributor vs RBAC Administrator (why both): Contributor = create/manage resources but can't grant access; RBAC Administrator = can create role assignments, needed for Terraform's Key Vault roles
- Service connection scope = whole subscription, because the pipeline creates `rg-gglab` and reads state in `rg-tfstate`
- Idempotent script = safe to run more than once with the same result (`grant-pipeline-roles.ps1` skips roles that already exist)
- Environment + approval = `lab` environment with me as approver; the Apply stage pauses until I approve
- Never hardcode IDs in a public repo: pass them as script parameters

#### Thu, Nov 19
 
- Pipeline order: trigger > pool > variables > stages > jobs > steps
- `trigger` vs `pr`: trigger = runs on pushes/merges to `main` (filtered by `paths`); pr = runs Validate + Plan on every pull request to `main`
- Path filters: `paths: include: [terraform/*, pipelines/*]` skips runs when only other folders change (e.g., `app/`, `k8s/`)
- Job vs deployment job: job = runs steps on an agent; deployment job = targets an environment, so approvals and deployment history apply
- Environment + approval check = the Apply stage pauses until I approve it in Azure DevOps
- `condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))` = Apply only runs on `main`, never on PR branches
- `ARM_USE_OIDC` + `ARM_OIDC_TOKEN` = Terraform signs in with the service connection's short-lived token (workload identity federation), no stored secret
- `addSpnToEnvironment: true` = exposes `$servicePrincipalId`, `$tenantId`, `$idToken` to the inline script
- Pipeline YAML scripts stay Bash because they run on the Linux agent, not my Mac
- Branch protection = `main` requires a PR and a passing pipeline check before merge
- YAML keys are case-sensitive and indentation decides where a key belongs ("Unexpected value" = wrong place or wrong spelling)
- From now on: `apply` runs only in the pipeline; locally I only run `plan`
 
#### Fri, Nov 20
 
- Image vs container: image = read-only template built by `docker build`; container = a running copy made by `docker run` (each run makes a new one)
- `FROM` base image | `WORKDIR` working folder | `COPY` files into the image | `RUN` command at build time | `EXPOSE` documents the port | `CMD` command when the container starts
- Why copy requirements.txt before app.py: Docker caches each layer, so the pip install layer is reused when only code changes
- Why non-root user: if the app is compromised, the attacker doesn't get root in the container
- Why `0.0.0.0` in CMD: so traffic from outside the container can reach the app
- `docker build -t name:tag dir/` = build | `run -p 8080:8080` = map Mac port to container port | `ps` = running containers | `ps -a` = all | `logs` = app output | `exec` = run a command inside
- `--rm` = delete container when it stops | `start`/`stop` = reuse an existing container | `docker container prune` = remove stopped ones
- Long options use two dashes (`--rm`), single letters use one (`-p`, `-d`)
- Mac ARM vs Azure amd64: local images on Apple Silicon are ARM; for Azure use `az acr build` or `docker buildx build --platform linux/amd64`
- `brew install --cask docker` = Docker Desktop app (plain `brew install docker` is only the CLI)
- venv = per-project Python packages; select it in VS Code so it recognizes Flask
 
#### Sat, Nov 21
 
- Pod = smallest unit Kubernetes runs (wraps one or more containers) | ReplicaSet = keeps N pods running | Deployment = manages ReplicaSets and rolling updates | Service = stable address that load-balances to pods
- Labels/selectors = Service and Deployment find pods by label (`app: hello`); they must match
- Readiness vs liveness probe: readiness = only send traffic when `/health` responds; liveness = restart the container if `/health` stops responding
- Requests vs limits: requests = resources reserved for scheduling (HPA needs CPU requests); limits = maximum a container can use
- `imagePullPolicy: IfNotPresent` = use the locally built image instead of pulling from a registry
- ClusterIP = internal-only Service address; EXTERNAL-IP `<none>` is normal
- Endpoints = pod IPs behind a Service; `<none>` means the selector doesn't match or pods aren't ready
- `kubectl get / describe / logs / apply / scale / port-forward / delete` = list / details + events / app output / create or update from YAML / change replicas / reach a Service from my Mac / remove
- `kubectl port-forward svc/hello 8080:80` = Mac port 8080 → Service port 80 → pod port 8080
- Self-healing: deleted a pod and the Deployment replaced it automatically
- Docker Desktop Kubernetes = local 1-node cluster, context `docker-desktop`; stop it by quitting Docker Desktop or turning Kubernetes off
- Docker vs Kubernetes: Docker builds and runs containers on one machine; Kubernetes keeps containers running across a cluster (scaling, self-healing, rolling updates)
 
#### Sun, Nov 22
 
- Python list vs dict: list = ordered items by position (`names[0]`); dict = key/value pairs looked up by key (`tags["owner"]`)
- String method I used: `.upper()` / `.split()` (replace with the one you used)
- Service Fabric in one line: Microsoft's older platform for running microservices (stateless and stateful); Suncoast is moving these to Kubernetes
- APIM in one line: a gateway in front of APIs for auth, rate limiting, transformation, and logging in one place
- Zero trust 3 principles: verify explicitly, use least privilege, assume breach 