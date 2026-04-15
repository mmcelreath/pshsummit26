function ConvertFrom-MdlsOutput {
    [CmdletBinding()]
    param (
        [string[]]$MdlsOutput
    )

    Write-Verbose "Starting ConvertFrom-MdlsOutput with $($MdlsOutput.Count) lines of input."

    $result = @{}
    $currentKey = $null
    $arrayValues = @()

    foreach ($line in $MdlsOutput) {
        if ($line -match '^\s*$') {
            Write-Verbose "Skipping empty line."
            continue
        }

        # Check if this is a key line (contains =)
        if ($line -match '^(\w+)\s*=\s*(.*)$') {
            # Save previous array if exists
            if ($currentKey -and $arrayValues.Count -gt 0) {
                $result[$currentKey] = $arrayValues -join ","
                Write-Verbose "Saved array for key '$currentKey' with $($arrayValues.Count) values."
                $arrayValues = @()
            }

            $currentKey = $matches[1]
            $value = $matches[2].Trim()
            Write-Verbose "Found key '$currentKey' with value '$value'."

            # Handle different value types
            if ($value -eq '(') {
                # Start of array
                $arrayValues = @()
                Write-Verbose "Starting array collection for key '$currentKey'."
            }
            elseif ($value -match '^\(.*\)$') {
                # Single line array or empty
                $result[$currentKey] = $value -replace '[()]', ''
                Write-Verbose "Set single line array for key '$currentKey'."
            }
            else {
                $result[$currentKey] = $value -replace '^"|"$', ''
                Write-Verbose "Set value for key '$currentKey'."
            }
        }
        else {
            # Continuation line (part of array or multiline value)
            $trimmedLine = $line.Trim() -replace '^"|"$|,\s*$', '' -replace '^\(|\)$', ''
            if ($trimmedLine -and $trimmedLine -ne ')') {
                $arrayValues += $trimmedLine
                Write-Verbose "Added continuation value '$trimmedLine' to array for key '$currentKey'."
            }
        }
    }

    # Save last array if exists
    if ($currentKey -and $arrayValues.Count -gt 0) {
        $result[$currentKey] = $arrayValues -join ","
        Write-Verbose "Saved final array for key '$currentKey' with $($arrayValues.Count) values."
    }

    Write-Verbose "Completed ConvertFrom-MdlsOutput, returning $($result.Keys.Count) properties."
    return [PSCustomObject]$result
}