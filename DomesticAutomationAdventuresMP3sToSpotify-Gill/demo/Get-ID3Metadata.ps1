function Get-ID3Metadata {
    [CmdletBinding()]
    param (
        [string]$DirectoryPath
    )
    try {
        Write-Verbose "Starting Get-ID3Metadata for directory: $DirectoryPath"

        # Get all multimedia files in the directory
        $files = Get-ChildItem -LiteralPath $DirectoryPath -Recurse -File | Where-Object {
            $_.Extension -match '\.(mp3|mp4|m4a|flac|wav)$'
        }

        Write-Verbose "Found $($files.Count) multimedia files in $DirectoryPath."

        if ($files.Count -eq 0) {
            Write-Output "No multimedia files found in the directory."
            return
        }

        # Initialize an arraylist to store metadata
        $metadataList = [System.Collections.ArrayList]@()

        # Check if running on macOS
        #if ($PSVersionTable.Platform -eq "Unix" -and $PSVersionTable.OS -like "MacOS*") {
        if($IsMacOS) {
            Write-Verbose "Running on macOS, using ffprobe for metadata extraction."
            foreach ($file in $files) {
                Write-Verbose "Processing file: $($file.FullName)"
                <#Using ffprobe, but leaving this for posterity...
                $mdlsOutput = @(mdls $file.FullName 2>/dev/null)
                $mdlsObject = ConvertFrom-MdlsOutput -MdlsOutput $mdlsOutput

                $metadata = [PSCustomObject]@{
                    FileName = $file.Name
                    Title    = $mdlsObject.kMDItemTitle
                    Album    = $mdlsObject.kMDItemAlbum
                    Artists  = $mdlsObject.kMDItemAuthors
                    Genre    = $mdlsObject.kMDItemMusicalGenre
                    Year     = $mdlsObject.kMDItemRecordingYear
                    Comment  = ""
                }#>

                $tags = (( & ffprobe -v quiet -print_format json -show_format -show_streams $file.FullName ) | ConvertFrom-Json).format.tags
                $metadata = [PSCustomObject]@{
                    FileName = (Split-Path $file.FullName -Leaf)
                    Title    = $tags.title
                    Artists   = $tags.artist
                    Album    = $tags.album
                    Genre    = $tags.genre
                    Year     = $tags.date
                }

                $metadataList.Add($metadata) | Out-Null
                Write-Verbose "Extracted metadata for $($file.Name): Title='$($tags.title)', Artist='$($tags.artist)'"
            }
        }
        elseif ($IsWindows) {
            Write-Verbose "Running on Windows, using Shell.Application for metadata extraction."
            # Windows: Use COM object
            $shell = New-Object -ComObject Shell.Application
            foreach ($file in $files) {
                Write-Verbose "Processing file: $($file.FullName)"
                $folder = $shell.Namespace((Get-Item -LiteralPath $file.DirectoryName).FullName)
                $item = $folder.ParseName($file.Name)
                $MetadataConstants = @{
                    Title   = 21
                    Album   = 14
                    Artists = 13
                    Genre   = 16
                    Year    = 15
                    Comment = 24
                }
                # Extract ID3 metadata
                $metadata = [PSCustomObject]@{
                    FileName = $file.Name
                    Title    = $folder.GetDetailsOf($item, $MetadataConstants.Title)
                    Album    = $folder.GetDetailsOf($item, $MetadataConstants.Album)
                    Artists  = $folder.GetDetailsOf($item, $MetadataConstants.Artists)
                    Genre    = $folder.GetDetailsOf($item, $MetadataConstants.Genre)
                    Year    = $folder.GetDetailsOf($item, $MetadataConstants.Year)
                    Comment  = $folder.GetDetailsOf($item, $MetadataConstants.Comment)
                }

                $metadataList.Add($metadata) | Out-Null
                Write-Verbose "Extracted metadata for $($file.Name): Title='$($metadata.Title)', Artist='$($metadata.Artists)'"
            }
        }
        else {
            Write-Output "Unsupported platform. This function is designed for Windows and macOS."
            return
        }

        Write-Verbose "Completed Get-ID3Metadata, extracted metadata for $($metadataList.Count) files."
        # Return the metadata list
        return $metadataList
    }
    catch {
        Write-Error $_
    }
}