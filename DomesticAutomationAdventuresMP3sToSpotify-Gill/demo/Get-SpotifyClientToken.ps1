function Get-SpotifyClientToken {
    [CmdletBinding()]
    param($sensitive)
    Write-Verbose "Starting Get-SpotifyClientToken."
    $authUrl = "https://accounts.spotify.com/api/token"
    $headers = @{ "Authorization" = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($sensitive.clientId + ':' + $sensitive.clientSecret)) }
    $body = @{ "grant_type" = "client_credentials"; "client_id" = $sensitive.clientId; "client_secret" = $sensitive.clientSecret }
    Write-Verbose "Requesting client credentials token from Spotify."
    $tokenResponse = Invoke-RestMethod -Uri $authUrl -Method Post -Headers $headers -Body $body
    Write-Verbose "Successfully obtained client token."
    return $tokenResponse.access_token
}