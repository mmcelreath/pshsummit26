
# In PowerShell, you can use the 'ConvertFrom-Json' 
# cmdlet to parse JSON data and check it against a schema. 


# native powershell validation of parameters example

function Test-Sample {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateScript({ $_ -match '^[0-9]+$' })]
        [string]$phoneNumber, # must be a string as we can start with 0
        [Parameter(Mandatory=$false)]
        [ValidateSet('Home', 'Work', 'Mobile')]
        [string]$phoneType
    )
    Write-Host "Phone number: $phoneNumber, Phone type: $phoneType"
    
}

Test-Sample -phoneNumber "0123456789" -phoneType "Home" # Valid input
Test-Sample -phoneNumber "0123456789" -phoneType "Fax"  # Invalid phone type
Test-Sample -phoneNumber "123-456-7890" -phoneType "Mobile " # Invalid phone number format
Test-Sample -phoneNumber "1234-567890" -phoneType "Fax" # Both inputs are invalid




function Test-SampleJSON {
    [CmdletBinding()]
    param (
        $phoneNumber,
        $phoneType
    )
    
    $jsonSchemaHashtable = @{
        '$schema'    = 'http://json-schema.org/draft-07/schema#'
        'type'       = 'object'
        'properties' = @{
            'phoneNumber'    = @{
                'type' = 'string'
                'pattern' = '^[0-9]+$' # Must be a string of digits
                'description' = 'Phone number must be a string of digits, can start with 0'
                'errorMessage' = 'Invalid phone number format. It must be a string of digits, and can start with 0.'
            }
            'phoneType'     = @{
                'type'    = 'string'
                'enum' = @('Home', 'Work', 'Mobile') # Allowed values
                'description' = 'Phone type must be one of: Home, Work, Mobile'
                'errorMessage' = 'Invalid phone type. It must be one of: Home, Work, Mobile.'
            }
        }
        'required'   = @('phoneNumber')
    }
    if (-not($PSBoundParameters | ConvertTo-Json -Depth 6 | Test-Json -Schema $($jsonSchemaHashtable | Convertto-Json -Depth 6))) {
        return
    }
    
    return $PSBoundParameters

}

Test-SampleJSON -phoneNumber "0123456789" -phoneType "Home" # Valid input
Test-SampleJSON -phoneNumber "0123456789" -phoneType "Fax"  # Invalid phone type
Test-SampleJSON -phoneNumber "123-456-7890" -phoneType "Mobile " # Invalid phone number format
Test-SampleJSON -phoneNumber "123-456-7890" -phoneType "Fax" # Both inputs are invalid
