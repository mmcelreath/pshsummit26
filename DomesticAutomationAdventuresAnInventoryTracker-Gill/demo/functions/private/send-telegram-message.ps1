<#
    .SYNOPSIS
        Sends a Telegram message
    .DESCRIPTION
        This function will attempt to send a message via Telegram.
#>
function Send-TelegramMessage {
    [CmdletBinding()]
    param( 
        # String message that has been created via the New-TelegramMessage function
        [Parameter(Mandatory)] [string] $Message,
        # Telegram Token of the API bot
        [Parameter(Mandatory)] [string] $TelegramToken,
        # ID of the Telegram chat the message will be sent to
        [Parameter(Mandatory)] [string] $TelegramChatID
    )
    BEGIN { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 }
    PROCESS {
        Write-Verbose "Executing: [Send-TelegramMessage]"
        try {
            [void](Invoke-RestMethod -Uri "https://api.telegram.org/bot$TelegramToken/sendMessage?chat_id=$TelegramChatID&text=$($Message)") 
            Write-Verbose "Telegram message sent..."
        } catch {
            Write-Error "Error sending Telegram message. [$($Error[0].Exception.Message)]"
        }
    }
    END { }
    CLEAN { }
} # Send-TelegramMessage