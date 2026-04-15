function Set-InitialDriverConfig {
    param(
        [string] $Path = (Get-Location | Select-Object -ExpandProperty Path)
    )
    Set-Location -Path $Path
    Get-ChildItem -Recurse -Path .\functions\ -File -Filter *.ps1 | ForEach-Object { . $_.FullName }
} # Set-InitialDriverConfig
function Invoke-TelegramDemo {
    $params = @{
        Path           = Join-Path -Path (Get-Location) -ChildPath '\data\lm-inventory-example.csv'
        Telegram       = $true
        TelegramChatID = $env:Telegram_LMTracker_ChatID
        TelegramToken  = $env:Telegram_LMTracker_Token
    }
    Invoke-LatchedMamaInventoryNotifier @params
} # Invoke-TelegramDemo
function Invoke-PSPushoverDemo {
    $params = @{
        Path               = Join-Path -Path (Get-Location) -ChildPath '\data\lm-inventory-example.csv'
        PSPushover         = $true
        PSPushoverUsrToken = $env:PSPushover_LMTracker_UsrToken 
        PSPushoverAppToken = $env:PSPushover_LMTracker_AppToken
    }
    Invoke-LatchedMamaInventoryNotifier @params
} # Invoke-PSPushoverDemo

Set-InitialDriverConfig
Invoke-TelegramDemo
Invoke-PSPushoverDemo