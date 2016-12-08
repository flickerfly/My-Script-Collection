Function Set-LocalUser {
    <#
    .SYNOPSIS 
    Manage local user accounts on a computer or list of computers 

    .DESCRIPTION
This is a function to be used as a part of managing Local User accounts. It can be called from other scripts so that it is available in the following way:
. ./Set-LocalUser.ps1

Thanks to Reddit /u/Namaha, original author. 
https://www.reddit.com/r/PowerShell/comments/2eum4f/function_to_create_andor_manipulate_a_local_user/?st=iwf81nka&sh=14b6a0

    .PARAMETER UserName 
    This field is required and is assumed to be the first argument.
    .PARAMETER ComputerName
    A single computer name or list of names one per line. It can be populated from Active Directory by importing the proper module and running command as follows:

    $Computers = Get-ADComputer -Filter { OperatingSystem -Like '*Server*' } -Properties OperatingSystem | Select -Expand DNSHostName

    Then using this $Computers variable as the value of the -ComputerName parameter.
    .PARAMETER Password
    .PARAMETER Description
    What should the user description be set to
    .PARAMETER AddGroup
    Set the group names that the user should be added to.
    .PARAMETER Disable
    Disable the account
    .PARAMETER Enable
    Enable the account
    .PARAMETER Unlock
    Unlock the account
    .PARAMETER Remove
    Remove the account 
    .PARAMETER PasswordNeverExpire
    Set no expiration date on the password
    .PARAMETER UserMustChangePassword
    Force the password to be changed when next logging in.
    .PARAMETER Verbose
    Provide verbose output of what is happening. 
    .EXAMPLE    Manage the Local Admin account for all servers on your Active Directory Domain

Import-Module ActiveDirectory
. .\Set-LocalUser.ps1

$Computers = Get-ADComputer -Filter { OperatingSystem -Like '*Server*' } -Properties OperatingSystem | Select -Expand DNSHostName
echo $Computers

Set-LocalUser -UserName MyAdmin -Password "S3c437" -PasswordNeverExpire -ComputerName $Computers -AddGroup Administrators -Verbose

    .EXAMPLE
    Set-LocalUser -UserName MyAdmin -Remove

    .EXAMPLE
    # USAGE Example:

# Add a "TestAdmin" account to a list of computers and add to the local Administrators group 

$serverList = get-content "C:\servers.txt"
Set-LocalUser "TestAdmin" -Password "Password123" -ComputerName $serverList -AddGroup "Administrators"
    .EXAMPLE

# Disable local machine's "TestUser" account. 

Set-LocalUser "TestUser" -Disable

    .NOTES
    Must be run with Administrative credentials
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    param
    (
        [Parameter(Mandatory=$True,Position=1)]
            [string[]]$UserName,
        [Parameter(Mandatory=$False)]
            [string[]]$ComputerName,
        [Parameter(Mandatory=$False)]
            [string]$Password,
        [Parameter(Mandatory=$False)]
            [string]$Description,
        [Parameter(Mandatory=$False)]
            [string[]]$AddGroup,

        [Switch]$Disable,
        [Switch]$Enable,
        [Switch]$Unlock,
        [Switch]$Remove,
        [Switch]$PasswordNeverExpire,
        [Switch]$UserMustChangePassword
    )

    #If the $computerName parameter is omitted, default to the current machine
    if(!$ComputerName) {
        $ComputerName = $env:COMPUTERNAME
    }

    foreach($server in $ComputerName) {
        Write-Verbose "---------------------------------------"
        Write-Output "Starting on $server"

        foreach($UID in $UserName) {
            Write-Verbose "User: $UID"

            #gets computer info for $server
            $computer = [ADSI]"WinNT://$server,computer"

            #removes the user
            if($Remove -and $pscmdlet.ShouldProcess("$Server","Remove user `"$UID`"")) {
                $computer.delete("user",$UID)
                Write-Verbose "Removed Account"
                continue
            }

            #creates the user if it does not already exist
            if(![ADSI]::Exists("WinNT://$server/$UID") -and $pscmdlet.ShouldProcess("$Server","Create user `"$UID`"")){
                $user = $computer.Create("user", $UID)
                $user.SetPassword($Password)
                $user.Setinfo()
            }
            else {
                $user = [ADSI]"WinNT://$server/$UID"
                Write-Verbose "Account Already Exists"
            }

            if($Password -and $pscmdlet.ShouldProcess("$Server","Set Password of `"$UID`"")) {
                $user.SetPassword($Password)
                $user.Setinfo()
            }

            if($Description -and $pscmdlet.ShouldProcess("$Server","Set Description `"$Description`" for user `"$UID`"")) {
                $user.description = $Description
                $user.setinfo()
            }

            if($UserMustChangePassword -and $pscmdlet.ShouldProcess("$Server","Force user `"$UID`" to change password on next login")) {
                $user.PasswordExpired = 1
                $user.Setinfo()
            }

            if($Enable -and $pscmdlet.ShouldProcess("$Server","Enable user `"$UID`"")) {
                $user.userflags = 512
                $user.SetInfo()
            }

            if($Disable -and $pscmdlet.ShouldProcess("$Server","Disable user `"$UID`"")) {
                #Disables the user
                $user.userflags.value = $user_acc.userflags.value -bor "0x0002"
                $user.SetInfo()
            }

            if($Unlock -and $pscmdlet.ShouldProcess("$Server","Unlock user `"$UID`"")) {
                $user.IsAccountLocked = $False
                $user.SetInfo()
            }

            if($PasswordNeverExpire -and $pscmdlet.ShouldProcess("$Server","Set password for `"$UID`" to never expire")) {
                #sets user's password to never expire
                $user.UserFlags.value = $user.UserFlags.value -bor 0x10000
                $user.CommitChanges()
            }

            #adds user to local group(s)
            if($AddGroup -and $pscmdlet.ShouldProcess("$Server","Add user `"$UID`" to $AddGroup group")) {
                foreach($group in $AddGroup) {
                    $objGroup = [ADSI]("WinNT://$server/$Group")
                    $objGroup.PSBase.Invoke("Add",$user.PSBase.Path)
                }
            }
        }
    }
}
