<#
    .SYNOPSIS
        Assembles a new PSPushover Message
    .DESCRIPTION
        From an Instock Item, this function creates a message that should be sent via PSPushover.
    .OUTPUTS
        message: An assembled message object, to be used for parameter splatting
#>
function New-PSPushoverMessage {
    [CmdletBinding()]
    param(
        # An individual InStock Item/Product object
        [Parameter(Mandatory)] $Item
    )
    BEGIN { }
    PROCESS {
        $messageString = ($Item | 
            Select-Object @{N = 'Item'    ; E = { $_.product.name } },
            @{N = 'Size'    ; E = { $_.product.option1 } },
            @{N = 'Print'   ; E = { $_.product.option2 } },
            @{N = 'Price'   ; E = { '{0:C}' -f ($_.product.price / 100) } },
            @{N = 'Quantity'; E = { $_.product.inventory_quantity } } 
        ) | Sort-Object URL, Print, Size | Out-String
        $message = @{
            Attachment = Invoke-WebRequest -Uri $Item.product.featured_image.src | Select-Object -ExpandProperty Content
            Url        = ( $Item.item.URL + "?variant=" + $Item.product.id )
            UrlTitle   = $Item.product.name
            Message    = $messageString
        }
        $message
    }
    END { }
    CLEAN { }
} # New-PSPushoverMessage