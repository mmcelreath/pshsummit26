<#
    .SYNOPSIS
        Imports the PSPushover module
    .DESCRIPTION
        This function will install and import the PSPushover module if needed.
#>
function Import-PSPushoverModule {
    [CmdletBinding()]
    param()
    BEGIN { }
    PROCESS {
        Write-Verbose "Executing: [Import-PSPushoverModule]"
        if ( $psPushoverModule = Get-Module -ListAvailable | Where-Object Name -eq "joshooaj.PSPushover" ) {
            Write-Verbose "PSPushover module has been detected. Attempting import..."
            try { 
                $psPushoverModule | Import-Module
            }
            catch {
                Write-Error "PSPushover module was unable to be imported. [$($_.Exception.Message)] Halting."
                Exit
            }
        }
        else {
            Write-Verbose "PSPushover module was not detected. Attempting install..."
            Install-Module -Name "joshooaj.PSPushover" -Scope CurrentUser -Repository PSGallery -Force
            Import-PSPushover
        }
    }
    END { }
    CLEAN { }
} # Import-PSPushover