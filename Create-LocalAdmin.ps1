Import-Module ActiveDirectory
. .\Set-LocalUser.ps1

$Workstations = Get-ADComputer -Filter { OperatingSystem -NotLike '*Server*' } -Properties OperatingSystem | Select -Expand DNSHostName
$Servers = Get-ADComputer -Filter { OperatingSystem -Like '*Server*' } -Properties OperatingSystem | Select -Expand DNSHostName

Set-LocalUser -UserName OrgAdmin -Password "Secret" -PasswordNeverExpire -ComputerName $Servers -AddGroup Administrators -Description "Local Administrator for My Org" -Verbose
