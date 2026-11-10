Param(
    [Parameter(Mandatory=$true)][string[]]$computers)
foreach ($computername in $computers) {
    Get-CimInstance -ClassName Win32_OperatingSystem `
        -ComputerName $ComputerName | 
        fl numberofprocessors, totalphysicalmemory
}