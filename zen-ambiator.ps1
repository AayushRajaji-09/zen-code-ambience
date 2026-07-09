# ══════════════════════════════════════════════════════════════════════════════
#   ZEN AMBIATOR  //  Focus · Flow · Silence   (CLI Mixer v2.2)
# ══════════════════════════════════════════════════════════════════════════════
#   Run in PowerShell to play and mix background ambient sounds from terminal.
# ══════════════════════════════════════════════════════════════════════════════

Add-Type -AssemblyName PresentationCore

# ─── Track Library ────────────────────────────────────────────────────────────
$NOCTUNE    = "https://raw.githubusercontent.com/karthiknvd/noctune/main/sounds"
$SOUNDHELIX = "https://www.soundhelix.com/examples/mp3"

$trackLibrary = @{
    "1" = @{ Name = "Heavy Rain";         Emoji = "🌧";  Desc = "Deep rainfall, thunderous and still";     Tracks = @("$NOCTUNE/rain.mp3",    "$SOUNDHELIX/SoundHelix-Song-6.mp3",  "$SOUNDHELIX/SoundHelix-Song-12.mp3", "$SOUNDHELIX/SoundHelix-Song-16.mp3", "$SOUNDHELIX/SoundHelix-Song-8.mp3") }
    "2" = @{ Name = "Thunder Storm";      Emoji = "⛈";   Desc = "Electric skies, raw and alive";           Tracks = @("$NOCTUNE/thunder.mp3", "$SOUNDHELIX/SoundHelix-Song-11.mp3", "$SOUNDHELIX/SoundHelix-Song-15.mp3", "$SOUNDHELIX/SoundHelix-Song-7.mp3") }
    "3" = @{ Name = "Train Journey";      Emoji = "🚂";  Desc = "Rolling tracks, wandering thoughts";      Tracks = @("$NOCTUNE/train.mp3",   "$SOUNDHELIX/SoundHelix-Song-14.mp3", "$SOUNDHELIX/SoundHelix-Song-15.mp3", "$SOUNDHELIX/SoundHelix-Song-10.mp3") }
    "4" = @{ Name = "Cafe Chatter";       Emoji = "☕";  Desc = "Warm murmurs, coffee and keystrokes";     Tracks = @("$SOUNDHELIX/SoundHelix-Song-2.mp3",  "$SOUNDHELIX/SoundHelix-Song-4.mp3",  "$SOUNDHELIX/SoundHelix-Song-6.mp3",  "$SOUNDHELIX/SoundHelix-Song-10.mp3", "$SOUNDHELIX/SoundHelix-Song-13.mp3") }
    "5" = @{ Name = "Lofi Focus";         Emoji = "🎧";  Desc = "Mellow beats for deep work";              Tracks = @("$SOUNDHELIX/SoundHelix-Song-1.mp3",  "$SOUNDHELIX/SoundHelix-Song-5.mp3",  "$SOUNDHELIX/SoundHelix-Song-9.mp3",  "$SOUNDHELIX/SoundHelix-Song-13.mp3", "$SOUNDHELIX/SoundHelix-Song-15.mp3") }
    "6" = @{ Name = "Deep Focus Piano";   Emoji = "🎹";  Desc = "Cinematic keys, unhurried and pure";      Tracks = @("$SOUNDHELIX/SoundHelix-Song-3.mp3",  "$SOUNDHELIX/SoundHelix-Song-7.mp3",  "$SOUNDHELIX/SoundHelix-Song-10.mp3", "$SOUNDHELIX/SoundHelix-Song-14.mp3", "$SOUNDHELIX/SoundHelix-Song-16.mp3", "$SOUNDHELIX/SoundHelix-Song-8.mp3") }
    "7" = @{ Name = "Claude FM";          Emoji = "🤖";  Desc = "AI-curated generative soundscape";        Tracks = @("$SOUNDHELIX/SoundHelix-Song-1.mp3",  "$SOUNDHELIX/SoundHelix-Song-4.mp3",  "$SOUNDHELIX/SoundHelix-Song-9.mp3") }
    "8" = @{ Name = "Lofi Radio Live";    Emoji = "📡";  Desc = "Uninterrupted chillhop, always on";       Tracks = @("https://streams.fluxfm.de/Chillhop/mp3-128/") }
    "9" = @{ Name = "White Noise";        Emoji = "📻";  Desc = "Procedural static, tuned for focus";      Tracks = @("$SOUNDHELIX/SoundHelix-Song-11.mp3", "$SOUNDHELIX/SoundHelix-Song-12.mp3") }
}

# ─── Player State ─────────────────────────────────────────────────────────────
$players         = @{}
$currentTrackIdx = @{}
$isPlaying       = @{}
$masterVolume    = 80

foreach ($key in $trackLibrary.Keys) {
    $players[$key]         = New-Object System.Windows.Media.MediaPlayer
    $currentTrackIdx[$key] = 0
    $isPlaying[$key]       = $false
    $initialUrl = $trackLibrary[$key].Tracks[0]
    $players[$key].Open((New-Object System.Uri($initialUrl)))
}

# ─── Helpers ──────────────────────────────────────────────────────────────────
function Set-PlayerVolume($key) {
    $players[$key].Volume = $masterVolume / 100
}

function Stop-All() {
    foreach ($key in $trackLibrary.Keys) {
        $players[$key].Stop()
        $isPlaying[$key] = $false
    }
}

function Get-VolBar($vol) {
    $filled = [Math]::Round($vol / 10)
    $empty  = 10 - $filled
    $bar    = ("█" * $filled) + ("░" * $empty)
    return "[$bar] $vol%"
}

function Get-TrackInfo($key) {
    $ch    = $trackLibrary[$key]
    $idx   = $currentTrackIdx[$key]
    $total = $ch.Tracks.Count
    if ($key -eq "8") { return "Live Radio Stream  " }
    if ($idx -eq ($total - 1)) { return "Live · Radio       " }
    return ("Track " + ($idx + 1) + " of " + ($total - 1)).PadRight(19)
}

# ─── Easter Egg Greeting ──────────────────────────────────────────────────────
try {
    $synthCmd = "Add-Type -AssemblyName System.Speech; (New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Zen Ambiator initialized. Focus mode ready.')"
    powershell -WindowStyle Hidden -Command $synthCmd
} catch {}

# ─── Main Loop ────────────────────────────────────────────────────────────────
$running = $true
while ($running) {
    Clear-Host

    # Header
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════════════════╗" -ForegroundColor DarkMagenta
    Write-Host "  ║          Z E N   A M B I A T O R   //   v2.2               ║" -ForegroundColor Magenta
    Write-Host "  ║          Focus · Flow · Silence                             ║" -ForegroundColor DarkGray
    Write-Host "  ╚══════════════════════════════════════════════════════════════╝" -ForegroundColor DarkMagenta
    Write-Host "  Master Volume  $(Get-VolBar $masterVolume)" -ForegroundColor DarkCyan
    Write-Host ""

    # Categories
    $categories = @(
        @{ Header = "🌿  NATURE";   Keys = @("1") },
        @{ Header = "⛈   WEATHER"; Keys = @("2") },
        @{ Header = "🔥  COZY";     Keys = @("3", "4") },
        @{ Header = "🎵  MUSIC";    Keys = @("5", "6", "7", "8", "9") }
    )

    foreach ($cat in $categories) {
        Write-Host ("  ┌─ " + $cat.Header + " " + ("─" * (48 - $cat.Header.Length))) -ForegroundColor Yellow
        foreach ($key in $cat.Keys) {
            $ch         = $trackLibrary[$key]
            $trackInfo  = Get-TrackInfo $key
            $statusIcon = if ($isPlaying[$key]) { "▶ PLAYING" } else { "── idle  " }
            $statusColor = if ($isPlaying[$key]) { "Cyan" } else { "DarkGray" }

            Write-Host ("  │  [" + $key + "] " + $ch.Emoji + " ") -NoNewline -ForegroundColor DarkGray
            Write-Host ($ch.Name.PadRight(20)) -NoNewline -ForegroundColor White
            Write-Host $trackInfo -NoNewline -ForegroundColor DarkCyan
            Write-Host $statusIcon -ForegroundColor $statusColor
        }
        Write-Host "  └" -ForegroundColor DarkGray
        Write-Host ""
    }

    # Commands
    Write-Host "  ╔══ COMMANDS ══════════════════════════════════════════════════╗" -ForegroundColor DarkGray
    Write-Host "  ║  [1-9]  Toggle channel play     s [n]  Skip to next track   ║" -ForegroundColor DarkGray
    Write-Host "  ║  mv [0-100]  Set master volume  m  Pause all   q  Quit      ║" -ForegroundColor DarkGray
    Write-Host "  ╚══════════════════════════════════════════════════════════════╝" -ForegroundColor DarkGray
    Write-Host ""

    $rawInput = Read-Host "  Command"
    $parts    = $rawInput.Trim().Split(" ")
    $cmd      = $parts[0].ToLower()

    switch ($cmd) {
        "q"    { Stop-All; $running = $false }
        "exit" { Stop-All; $running = $false }
        "m"    { Stop-All }
        "mv"   {
            if ($parts.Length -gt 1) {
                $newVal = 0
                if ([int]::TryParse($parts[1], [ref]$newVal)) {
                    $masterVolume = [Math]::Max(0, [Math]::Min(100, $newVal))
                    foreach ($k in $trackLibrary.Keys) { Set-PlayerVolume $k }
                }
            }
        }
        "s"    {
            if ($parts.Length -gt 1) {
                $targetKey = $parts[1]
                if ($trackLibrary.ContainsKey($targetKey)) {
                    $tracks = $trackLibrary[$targetKey].Tracks
                    $currentTrackIdx[$targetKey] = ($currentTrackIdx[$targetKey] + 1) % $tracks.Count
                    $wasPlaying = $isPlaying[$targetKey]
                    $players[$targetKey].Stop()
                    $nextUrl = $tracks[$currentTrackIdx[$targetKey]]
                    $players[$targetKey].Open((New-Object System.Uri($nextUrl)))
                    if ($wasPlaying) {
                        Set-PlayerVolume $targetKey
                        $players[$targetKey].Play()
                    }
                }
            }
        }
        default {
            if ($trackLibrary.ContainsKey($cmd)) {
                if ($isPlaying[$cmd]) {
                    $players[$cmd].Pause()
                    $isPlaying[$cmd] = $false
                } else {
                    Set-PlayerVolume $cmd
                    $players[$cmd].Play()
                    $isPlaying[$cmd] = $true
                }
            }
        }
    }
}

# Cleanup
Stop-All
foreach ($key in $players.Keys) { $players[$key].Close() }
