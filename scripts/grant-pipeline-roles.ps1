<#
.SYNOPSIS
    Grants the Azure DevOps service connection the roles the pipeline needs.
.EXAMPLE
    ./scripts/grant-pipeline-roles.ps1 -AppId <application-client id>
#> 

param(
    [parameter(mandatory)]
    [string]$AppId,

    [string]$SubscriptionId = (az account show --query id -o tsv)
)

$scope = "/subscriptions/$SubscriptionId"
$roles = @("Contributor", "Role Based Access Control Administrator")

foreach ($role in $roles) {
    $existing = az role assignment list --assignee $AppId --role $role --scope $scope --query "[0].id" -o tsv
    if ($existing) {
        Write-Host "Already has '$role' at $scope."
    } else {
        Write-Host "Grantiing '$role' at $scope..."
        az role assignment create --assignee $AppId --role $role --scope $scope | Out-Null
    }
}

Write-Host "`nCurrent role assignments:"
az role assignment list --assignee $AppId --all -o table
 