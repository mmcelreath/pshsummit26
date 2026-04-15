function Search-SpotifyTracks {
    [CmdletBinding()]
    param($meta, $accessToken)
    Write-Verbose "Starting Search-SpotifyTracks with $($meta.Count) metadata sets."
    $found = [System.Collections.ArrayList]@()
    $notFound = [System.Collections.ArrayList]@()
    $uris = [System.Collections.ArrayList]@()
    foreach ( $metaSet in $meta ) {
        Write-Verbose "Processing metadata set with $($metaSet.Count) tracks."
        foreach ( $track in $metaSet ) {
            $trackName = $track.Title
            $artistName = $track.Artists
            $albumName = $track.Album
            Write-Verbose "Searching for track: '$trackName' by '$artistName' from '$albumName'."
            $searchUrl = "https://api.spotify.com/v1/search?q=track:${trackName}+artist:${artistName}+album:${albumName}&type=track&limit=5"
            $searchHeaders = @{ "Authorization" = "Bearer $accessToken" }
            $searchResponse = Invoke-RestMethod -Uri $searchUrl -Method Get -Headers $searchHeaders
            if ($trackResponse = ($searchResponse.tracks.items | Where-Object { $_.name -eq $trackName })) {
                Write-Host ("Found: $($trackResponse.name) | $($trackResponse.artists[0].name) | $($trackResponse.album.name)")
                Write-Verbose "Found exact match for '$trackName'."
                $found.Add($track) | Out-Null
                $uris.Add(
                    [pscustomobject]@{
                        uri    = @($trackResponse.uri)
                        name   = $trackResponse.name
                        artist = $trackResponse.artists[0].name
                        album  = $trackResponse.album.name
                    }
                ) | Out-Null
            }
            else {
                Write-Verbose "No exact match, trying broader search."
                $searchUrl = "https://api.spotify.com/v1/search?q=track:${trackName}+artist:${artistName}&type=track&limit=1"
                $searchHeaders = @{ "Authorization" = "Bearer $accessToken" }
                $searchResponse = Invoke-RestMethod -Uri $searchUrl -Method Get -Headers $searchHeaders
                if ($trackUri = $searchResponse.tracks.items[0].uri) {
                    Write-Host ("Found: $($searchResponse.tracks.items[0].name) | $($searchResponse.tracks.items[0].artists.name) | $($searchResponse.tracks.items[0].album.name)")
                    Write-Verbose "Found match in broader search."
                    $found.Add($track) | Out-Null
                    $uris.Add(
                        [pscustomobject]@{
                            uri    = @($trackUri)
                            name   = $searchResponse.tracks.items[0].name
                            artist = $searchResponse.tracks.items[0].artists[0].name
                            album  = $searchResponse.tracks.items[0].album.name
                        }
                    ) | Out-Null
                }
                else {
                    Write-Warning ("Not Found: $($trackName) | $($artistName) | $($albumName)")
                    Write-Verbose "No match found for '$trackName'."
                    $notFound.Add($track) | Out-Null
                }
            }
        }
    }
    Write-Verbose "Completed Search-SpotifyTracks: Found $($found.Count), Not Found $($notFound.Count)."
    return @{Found = $found; NotFound = $notFound; Uris = $uris}
}