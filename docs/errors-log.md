# Errors-log

## Phase 1 (Nov 9–24)

| Date | Step | Error | Cause | Fix | Lesson |

| Nov 11 | B2 Azure Policy | `RequestDisallowedByPolicy` when running `az group create -n rg-test -l eastus` | The "Require a tag on resource groups" policy denies resource groups without an `owner` tag | Re-ran with `--tags owner=gabriel` | Expected result: Policy with a Deny effect blocks non-compliant resources at creation. Every resource group needs the `owner` tag from now on, including ones Terraform creates |

