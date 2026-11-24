# Errors-log

## Phase 1 (Nov 9–24)

| Date | Step | Error | Cause | Fix | Lesson |

| Nov 11 | B2 Azure Policy | `RequestDisallowedByPolicy` when running `az group create -n rg-test -l eastus` | The "Require a tag on resource groups" policy denies resource groups without an `owner` tag | Re-ran with `--tags owner=gabriel` | Expected result: Policy with a Deny effect blocks non-compliant resources at creation. Every resource group needs the `owner` tag from now on, including ones Terraform creates |

| Nov 17 | B8 Key Vault (shell) | `The term 'export' is not recognized as a name of a cmdlet, function, script file, or executable program` | VS Code terminal was running PowerShell (pwsh), not zsh; `export` is Bash/zsh syntax | Used `$env:TF_VAR_subscription_id = (az account show --query id -o tsv)`; moved all work to pwsh and added it to my `$PROFILE` | Check which shell the prompt is (`PS` = PowerShell) before running commands; translate Bash syntax to PowerShell |

| Nov 17 | B8 Key Vault | `AccessToKeyVaultDenied` on the `MY_SECRET` Key Vault reference (red X in Environment variables) | The web app's Key Vault Secrets User role hadn't taken effect when App Service first checked the reference, and App Service kept showing the cached failure | Confirmed the identity, role assignment, RBAC permission model, and secret in the portal, then restarted the app to force a new check (turned green) | Check configuration before changing code. Role assignments take minutes to take effect, and App Service caches Key Vault reference results until a restart or settings change |

| Nov 19 | B10 Pipeline | `/pipelines/azure-piplines.yml (line 33, col 13): Unexpected value 'displayName'` | `displayName` was spelled correctly but indented under the wrong parent, so YAML attached it to a level where it isn't allowed | Fixed the indentation so `displayName` lines up with `task:`/`script:`, then pushed to rerun the PR check | "Unexpected value" in pipeline YAML usually means wrong indentation or casing. Check the column number in the error, use spaces only |

| Nov 20 | B11 Docker | `unknown shorthand flag: 'r' in -rm` | Typed `-rm` with one dash, so Docker read it as the short flag `-r` | Used `--rm` (two dashes) | Long option names use two dashes, single letters use one. Retype dashes when pasting commands |

| Nov 20 | B11 Docker | VS Code: `Import "flask" could not be resolved` in app.py | Flask was only installed inside the container image, not in the Mac's Python | Created a venv, installed `requirements.txt`, selected it as the VS Code interpreter | Containers have their own packages. Use a venv so the editor matches the app's dependencies |
