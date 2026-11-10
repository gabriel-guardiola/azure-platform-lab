Param(
    [string]$ComputerName='ComputerDC01')
Get-wmiobject -ClassName Win32_OperatingSystem `
    -ComputerName $ComputerName | 
    fl numberofprocessors, totalphysicalmemory