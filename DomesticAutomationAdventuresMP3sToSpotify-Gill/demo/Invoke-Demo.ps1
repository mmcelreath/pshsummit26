. .\ConvertFrom-MdlsOutput.ps1
. .\Get-ID3Metadata.ps1
. .\Add-TrackToSpotifyPlaylist.ps1
. .\Get-MP3Folders.ps1
. .\Get-ID3MetadataFromFolderContents.ps1
. .\Get-SpotifyClientToken.ps1
. .\Search-SpotifyTracks.ps1
. .\Get-SpotifyUserToken.ps1
. .\Add-TracksToPlaylist.ps1

# Main script execution
$VerbosePreference = 'Continue' #'SilentlyContinue'

Write-Verbose "Starting main script execution."
$sensitive = Get-Content "sensitive.json" | ConvertFrom-Json
$folders = Get-MP3Folders
$metadata = Get-ID3MetadataFromFolderContents -folders $folders
$clientToken = Get-SpotifyClientToken -sensitive $sensitive
$searchResults = Search-SpotifyTracks -meta $metadata -accessToken $clientToken
$userToken = Get-SpotifyUserToken -sensitive $sensitive
Add-TracksToPlaylist -uris $searchResults.Uris -sensitive $sensitive -userAccessToken $userToken
Write-Verbose "Main script execution completed."