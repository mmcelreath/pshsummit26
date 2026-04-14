<#
    .SYNOPSIS
        Sends a test message via Telegram if necessary

    .DESCRIPTION
        If a particular Telegram API account isn't used frequently enough it will stagnate and eventually be disabled. This function sends a test message to help mitigate that.
#>
function Invoke-TelegramHealthCheck {
    [CmdletBinding()]
    param (
        # A ValidateSet of either Monthly or Constant. Constant will always send a message, whereas Monthly will only send a message on the first of the month at 10:00am-10:04am.
        [ValidateSet("Monthly", "Constant")] $HealthCheck = "Monthly"
    )
    BEGIN { }
    PROCESS {
        Write-Verbose "Executing: [Invoke-TelegramHealthCheck]"
        if ( ( $HealthCheck -eq "Constant" ) -or ( $HealthCheck -eq "Monthly" -and $( Get-Date ).Day -eq 1 -and $( Get-Date ).Hour -eq 10 -and $( Get-Date ).Minute -in (0..4) ) ) { 
            Write-Verbose "Sending Telegram Health Check message..."
            Send-TelegramMessage -Message ( "LatchedMama Alert (" + ( $( Get-Date ).ToString("MM-dd-yy HH:mm:ss") ) + ") : " + $HealthCheck.ToUpper() + " HEALTH CHECK" )
            Write-Verbose "Telegram Health Check message has been sent..."
        } else { Write-Verbose "Telegram Health Check message is not necessary..." }
    }
    END { }
    CLEAN { }
} # Invoke-HealthCheck