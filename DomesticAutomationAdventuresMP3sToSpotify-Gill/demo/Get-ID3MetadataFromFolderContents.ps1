function Get-ID3MetadataFromFolderContents {
    [CmdletBinding()]
    param($folders)
    Write-Verbose "Starting Get-ID3MetadataFromFolderContents with $($folders.Count) folders."
    $meta = [System.Collections.ArrayList]@()
    $metaFile = "MetaCheckpoint.json"
    if ( -not (Test-Path -Path $metaFile) ) {
        Write-Verbose "MetaCheckpoint.json not found, extracting metadata from folders."
        $folders | ForEach-Object {
            Write-Verbose "Processing folder: $($_.FullName)"
            $metadata = (Get-ID3Metadata -DirectoryPath $_.FullName) # ( Escape-SpecialCharacters -InputString $_.FullName) )
            #$metadata | Format-Table
            $meta.Add( $metadata ) | Out-Null
        }
        Write-Verbose "Saving metadata to MetaCheckpoint.json."
        Set-Content -Path $metaFile -Value ($meta | Convertto-Json)
    } else {
        Write-Verbose "Loading metadata from existing MetaCheckpoint.json."
    }
    $meta = Get-Content $metaFile | ConvertFrom-Json
    Write-Verbose "Completed Get-ID3MetadataFromFolderContents, returning metadata for $($meta.Count) sets."
    return $meta
}