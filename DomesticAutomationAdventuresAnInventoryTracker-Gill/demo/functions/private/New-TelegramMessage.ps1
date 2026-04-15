<#
    .SYNOPSIS
        Assembles a new Telegram Message

    .DESCRIPTION
        From Instock Items, this function creates a consolidated message that should be sent via Telegram.
    .OUTPUTS
        message: A string that is an assembled and consolidated message to be sent via Telegram
#>
function New-TelegramMessage {
    [CmdletBinding()]
    param( 
        # PSCustomObject of the PrintMember and InStockItem
        [Parameter(Mandatory)] $InStockItems 
    )
    BEGIN { }
    PROCESS {
        Write-Verbose "Executing: [New-TelegramMessage]"
        $message = "LatchedMama Alert (" + ( $( Get-Date ).ToString("MM-dd-yy HH:mm:ss") ) + ") :`n---------------------------------------"
        $message += ($InStockItems | 
            Select-Object @{N = 'URL' ; E = { $_.item.URL + "?variant=" + $_.product.id } },
            @{N = 'Size'    ; E = { $_.product.option1 } },
            @{N = 'Print'   ; E = { $_.product.option2 } },
            @{N = 'Price'   ; E = { '{0:C}' -f ($_.product.price / 100) } },
            @{N = 'Quantity'; E = { $_.product.inventory_quantity } } ) | Sort-Object URL, Print, Size | Format-List | Out-String
        $message += "---------------------------------------"
        Write-Verbose "Assembled Telegram message"
        $message
    }
    END { }
    CLEAN { }
} # New-TelegramMessage