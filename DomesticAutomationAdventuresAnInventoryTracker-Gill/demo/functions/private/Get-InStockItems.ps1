<#
    .SYNOPSIS
        Determines what products are in stock
    .DESCRIPTION
        Based on desired product information, grab latest product availability.
    .OUTPUTS
        ~InStockItems: A collection of PSCustomObjects containing item and product data for items that in-stock
#>
function Get-InStockItems {
    [CmdletBinding()]
    param( 
        # File path of CSV with desired product information
        [Parameter(Mandatory)] [string] $Path 
    )
    BEGIN { }
    PROCESS {
        Write-Verbose "Executing: [Get-InStockItems]"
        foreach ( $printGroup in ( (Get-Content $Path | ConvertFrom-Csv) | Where-Object Enabled -eq 'TRUE' | Group-Object -Property URL ) ) {
            try { 
                if ( ($restResponse = Invoke-RestMethod -Method Get -Uri ($printGroup.Name + '.js' ) -ErrorAction SilentlyContinue).available ) {
                    foreach ( $printMember in $printGroup.Group ) {
                        if ( $products = $restResponse.variants | Where-Object option2 -like ("*" + $printMember.Print.Trim() + "*") ) {
                            if ( $printMember.Sizes -eq '*' ) { $inStockItems = $products | Where-Object available }
                            else { $inStockItems = foreach ( $size in ( $printMember.Sizes.split(',') ) ) { $products | Where-Object { $_.option1 -eq $size -and $_.available } } }
                            foreach ( $inStockItem in $inStockItems ) {
                                Write-Verbose "Found InStockItem: [$($inStockItem.Name)]"
                                [pscustomObject]@{
                                    item    = $printMember
                                    product = $inStockItem
                                }
                            }
                        }
                    }
                }
            } catch {
                Write-Error $_.Exception.Message
            }
        }
    }
    END { }
    CLEAN { }
} # Get-InStockItems