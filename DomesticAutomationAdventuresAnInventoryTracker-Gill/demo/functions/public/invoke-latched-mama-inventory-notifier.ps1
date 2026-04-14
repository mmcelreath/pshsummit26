<#
    .SYNOPSIS
        Checks live LatchedMama inventory for in-stock items

    .DESCRIPTION
        Checks live LatchedMama inventory against a desired list of products to notify users of in-stock items
#>
function Invoke-LatchedMamaInventoryNotifier {
    [CmdletBinding(DefaultParametersetName = 'None')]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path -Path $_ }, ErrorMessage = "The supplied path does not exist")]
        [ValidateScript({ (Get-Item -Path $_).Extension -eq '.csv' }, ErrorMessage = "The supplied file is not a CSV")]
        [ValidateScript({ ((Import-Csv -Path $_ | Get-member -MemberType 'NoteProperty' | Select-Object -ExpandProperty 'Name' | Sort-Object) -join ',') -eq 'Enabled,Print,Sizes,URL' }, ErrorMessage = "The supplied CSV does not contain the correct columns: 'Enabled,Print,Sizes,URL'")]
        [string] $Path,
        [Parameter(ParameterSetName = 'Telegram', Mandatory = $false) ] [switch] $Telegram = $false,
        [Parameter(ParameterSetName = 'Telegram', Mandatory = $true ) ] [string] $TelegramChatID,
        [Parameter(ParameterSetName = 'Telegram', Mandatory = $true ) ] [string] $TelegramToken,
        [Parameter(ParameterSetName = 'PSPushover', Mandatory = $false) ] [switch] $PSPushover = $false,
        [Parameter(ParameterSetName = 'PSPushover', Mandatory = $true ) ] [string] $PSPushoverUsrToken,
        [Parameter(ParameterSetName = 'PSPushover', Mandatory = $true ) ] [string] $PSPushoverAppToken
    )
    BEGIN {
        if ($PSPushover) { 
            Import-PSPushoverModule 
            Set-PSPushoverConfig -PSPushoverUsrToken $PSPushoverUsrToken -PSPushoverAppToken $PSPushoverAppToken
        }
    }
    PROCESS {
        if ($Telegram) { Invoke-TelegramHealthCheck -HealthCheck Monthly }
        if (($inStockItems = Get-InStockItems -Path $Path).Count -ne 0) { 
            if ($Telegram) { Send-TelegramMessage -Message (New-TelegramMessage -InStockItems $inStockItems) -TelegramToken $TelegramToken -TelegramChatID $TelegramChatID }
            if ($PSPushover) {
                Foreach ($inStockItem in $inStockItems) {
                    try{
                    $message = (New-PSPushoverMessage -Item $inStockItem)
                    Send-Pushover @message
                    Write-Verbose "Sending Pushover message for item: [$($inStockItem.product.Name)]"
                    } catch {
                        Write-Error "Unable to send Pushover message. [$($_.Exception.Message)]"
                    }
                }
            }
        }
    }
    END { }
    CLEAN { }
}