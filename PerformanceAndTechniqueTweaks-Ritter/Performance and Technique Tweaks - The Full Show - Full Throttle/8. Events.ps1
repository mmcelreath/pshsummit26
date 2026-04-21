# Have you heard of Events in PowerShell? 
# They are a powerful way to react to certain actions or triggers 
# in your PowerShell session.

# 1. Custom Events
Register-EngineEvent -SourceIdentifier "My.Custom.Event" -Action {
    # Write Window Title
    $($host.UI.RawUI.WindowTitle =  $($Event.MessageData))
}

# Trigger the custom event with some data
New-Event -SourceIdentifier "My.Custom.Event" -MessageData "✔ $($host.UI.RawUI.WindowTitle)" 

# 2. Built-in Events
# PowerShell has several built-in events, such as when the session is exiting or when it's
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
    if($(Get-MGContext)){
        Disconnect-MGGraph
    }
}

# You can also react to idle time in the session, 
# which is useful for things like auto-saving or refreshing data.
Register-EngineEvent -SourceIdentifier PowerShell.OnIdle -Action {
    Write-host '🎶Aaaaand I`m still standing...'
} | Out-Null

# Lets create something which motivates us dont get idle..
function Start-IdleEventDemo {

    Register-EngineEvent -SourceIdentifier "My.Custom.Event" -Action {
        # Write Window Title
        $($host.UI.RawUI.WindowTitle =  $($Event.MessageData))
    }

    $lyrics = " 🎤NEVER GONNA GIVE YOU UP; NEVER GONNA LET YOU DOWN🎤   "
    $global:scroll = $lyrics

    Register-EngineEvent -SourceIdentifier PowerShell.OnIdle -Action {
        $global:scroll = $global:scroll.Substring(1) + $global:scroll[0]
        $host.UI.RawUI.WindowTitle = $global:scroll
    } | Out-Null

}
cls

# 4. Timer Events
# You can also use timers to trigger events at specific intervals.

$timer = New-Object Timers.Timer
$timer.Interval = 1000 # 1 second
$timer.AutoReset = $true

Register-ObjectEvent -InputObject $timer -EventName Elapsed -Action {
    #Write-Host "$($EventArgs)"
    Write-Host "Timer ticked at $(Get-Date)"
    $EventArgs
} | Out-Null

$timer.Start()
