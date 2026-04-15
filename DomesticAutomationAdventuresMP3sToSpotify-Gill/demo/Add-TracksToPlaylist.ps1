function Add-TracksToPlaylist {
    [CmdletBinding()]
    param($uris, $sensitive, $userAccessToken)
    Write-Verbose "Starting Add-TracksToPlaylist with $($uris.Count) URIs."
    if ($uris.Count -ne 0) {
        Write-Verbose "Adding tracks to playlist $($sensitive.playlistId)."
        foreach ($uri in $uris | Sort-Object -Unique -Property uri) {
            Write-Verbose "Adding track '$($uri.name)' to playlist."
            Add-TrackToSpotifyPlaylist -ClientId $sensitive.clientId -ClientSecret $sensitive.clientSecret -RedirectUri "http://127.0.0.1:8000/callback" -PlaylistId $sensitive.playlistId -TrackUri $uri -accessToken $userAccessToken
        }
        Write-Verbose "Completed adding tracks to playlist."
    } else {
        Write-Verbose "No URIs to add."
    }
}