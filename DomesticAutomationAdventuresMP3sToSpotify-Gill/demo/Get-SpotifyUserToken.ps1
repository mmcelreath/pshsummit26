function Get-SpotifyUserToken {
    [CmdletBinding()]
    param($sensitive)
    Write-Verbose "Starting Get-SpotifyUserToken."
    $redirectUri = "http://127.0.0.1:8000/callback"
    $authUrl = ("https://accounts.spotify.com/authorize?client_id=" + $sensitive.clientId + "&response_type=code&redirect_uri=$redirectUri&scope=playlist-modify-public playlist-modify-private")
    Write-Verbose "Opening authorization URL in browser."
    Start-Process $authUrl
    Write-Host "Please authorize the application and enter the code from the redirect URL:"
    $authCode = Read-Host
    Write-Verbose "Received authorization code, exchanging for access token."
    # Step 2: Exchange Authorization Code for Access Token
    $tokenUrl = "https://accounts.spotify.com/api/token"
    $body = @{
        grant_type    = "authorization_code"
        code          = $authCode
        redirect_uri  = $redirectUri
        client_id     = $sensitive.clientId
        client_secret = $sensitive.clientSecret
    }
    $tokenResponse = Invoke-RestMethod -Uri $tokenUrl -Method Post -Body $body -ContentType "application/x-www-form-urlencoded"
    Write-Verbose "Successfully obtained user access token."
    return $tokenResponse.access_token
}