function Get-MP3Folders {
    [CmdletBinding()]
    param()
    Write-Verbose "Starting Get-MP3Folders."
    $folders = (Get-ChildItem "MP3" -Recurse -File) | Select-Object -Unique Directory | Select-Object -ExpandProperty Directory
    Write-Verbose "Found $($folders.Count) unique MP3 folders."
    return $folders
}