param([string]$Owner = "Gabriel")
Connect-AzAccount -UseDeviceAuthentication | Out-Null #skip if already signed in
Get-AzResource | Where-Object {$_.tags.owner -eq $Owner} |
Select-Object Name, ResourceType, ResourceGroupName, Location | 
Format-Table -AutoSize