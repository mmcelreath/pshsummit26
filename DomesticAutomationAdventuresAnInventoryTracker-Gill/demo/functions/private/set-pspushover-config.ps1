<#
    .SYNOPSIS
        Sets values for PSPushover
    .DESCRIPTION
        This function will configure PSPushover using passed-in parameters.
#>
function Set-PSPushoverConfig {
    [CmdletBinding()]
    param(
        # This is the Pushover User Token, corresponding to the receiving user
        [Parameter(Mandatory)] [string] $PSPushoverUsrToken,
        # This is the Pushover application token that will receive a notification
        [Parameter(Mandatory)] [string] $PSPushoverAppToken
    )
    BEGIN { }
    PROCESS { 
        Write-Verbose "Executing: [Set-PSPushoverConfig]"
        $usrToken = ConvertTo-SecureString -String $PSPushoverUsrToken -AsPlainText
        $appToken = ConvertTo-SecureString -String $PSPushoverAppToken -AsPlainText
        Set-PushoverConfig -Token $appToken -User $usrToken
        Write-Verbose "PSPushover has been configured"
    }
    END { }
    CLEAN { }
} # Set-PSPushoverConfig