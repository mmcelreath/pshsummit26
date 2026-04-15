# Domestic Automation Adventures: MP3s to Spotify

This session demonstrates a PowerShell automation workflow for scanning local MP3 files, extracting metadata, searching Spotify for matches, and adding those tracks to a playlist.

## What this demo includes

- `demo/` contains PowerShell helper scripts and the demo orchestration script
- `slides/` contains the session slide deck
- `sensitive.json` stores configuration for Spotify client credentials and playlist settings

## Demo workflow

1. Locate MP3 folders under `demo/MP3`
2. Extract metadata from each supported media file
3. Search Spotify for matching tracks on Spotify
4. Obtain Spotify user authorization for playlist modification
5. Add found tracks to the target Spotify playlist

## Usage

From `DomesticAutomationAdventuresMP3sToSpotify-Gill/demo`:

```powershell
./Invoke-Demo.ps1
```

The demo requires `sensitive.json` to be present in the session root with Spotify API client credentials and playlist configuration.

## Files

- `demo/Add-TrackToSpotifyPlaylist.ps1` - Adds a single Spotify track to a playlist.
- `demo/Add-TracksToPlaylist.ps1` - Adds multiple tracks to the playlist.
- `demo/ConvertFrom-MdlsOutput.ps1` - Parses macOS `mdls` output into a PowerShell object.
- `demo/Get-ID3Metadata.ps1` - Extracts metadata from local media files.
- `demo/Get-ID3MetadataFromFolderContents.ps1` - Aggregates folder metadata and caches results.
- `demo/Get-MP3Folders.ps1` - Finds MP3 folders under `demo/MP3`.
- `demo/Get-SpotifyClientToken.ps1` - Requests a Spotify client credentials token.
- `demo/Get-SpotifyUserToken.ps1` - Runs the Spotify authorization flow.
- `demo/Search-SpotifyTracks.ps1` - Searches Spotify for tracks matching local metadata.
- `demo/Invoke-Demo.ps1` - Orchestrates the full demo execution.
