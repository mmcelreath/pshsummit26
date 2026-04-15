function Add-TrackToSpotifyPlaylist {
    [CmdletBinding()]
    param (
        [string]$ClientId,
        [string]$ClientSecret,
        [string]$RedirectUri,
        [string]$PlaylistId,
        [pscustomobject]$TrackUri,
        $accessToken
    )

    Write-Verbose "Starting Add-TrackToSpotifyPlaylist for track '$($TrackUri.name)' to playlist $PlaylistId."

    # Authorization and token retrieval code...

    $addTracksUrl = "https://api.spotify.com/v1/playlists/$PlaylistId/tracks"
    $headers = @{
        Authorization = "Bearer $accessToken"
    }
    $body = @{
        uris = $TrackUri.uri
    }

    $maxRetries = 3
    $retryCount = 0
    $success = $false

    while (-not $success -and $retryCount -lt $maxRetries) {
        try {
            Write-Verbose "Attempting to add track (attempt $($retryCount + 1))."
            Invoke-RestMethod -Uri $addTracksUrl -Method Post -Headers $headers -Body ($body | ConvertTo-Json) -ContentType "application/json" -TimeoutSec 120 | Out-Null
            $success = $true
            Write-Host "Track: `"$($TrackUri.name)`", added to playlist successfully!"
            Write-Verbose "Successfully added track '$($TrackUri.name)'."
        }
        catch {
            Write-Verbose "Attempt $($retryCount + 1) failed: $_"
            Write-Host "Attempt $($retryCount + 1) failed: $_"
            $retryCount++
            Start-Sleep -Seconds 5
        }
    }

    if (-not $success) {
        Write-Host "Failed to add track: `"$($TrackUri.name)`", after $maxRetries attempts."
        Write-Verbose "Failed to add track '$($TrackUri.name)' after $maxRetries attempts."
    }
}