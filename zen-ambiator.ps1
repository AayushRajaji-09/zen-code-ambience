# ══════════════════════════════════════════════════════════════════════════════
#                     ZEN_AMBIATOR // OS_HUD_V2.1 (CLI Mixer)
# ══════════════════════════════════════════════════════════════════════════════
# Run this script in PowerShell to play and mix background ambient sounds directly
# from your terminal! 
# ══════════════════════════════════════════════════════════════════════════════

Add-Type -AssemblyName PresentationCore

# ─── Configuration & Track Library ───
$NOCTUNE = "https://raw.githubusercontent.com/karthiknvd/noctune/main/sounds"
$SOUNDHELIX = "https://www.soundhelix.com/examples/mp3"

$trackLibrary = @{
    "1"  = @{ Name = "Heavy Rain";         Emoji = "🌧️";  Tracks = @("$NOCTUNE/rain.mp3", "$SOUNDHELIX/SoundHelix-Song-6.mp3", "$SOUNDHELIX/SoundHelix-Song-12.mp3", "$SOUNDHELIX/SoundHelix-Song-16.mp3") }
    "2"  = @{ Name = "Forest Wind";        Emoji = "🌲";  Tracks = @("$NOCTUNE/forest.mp3", "$SOUNDHELIX/SoundHelix-Song-8.mp3", "$SOUNDHELIX/SoundHelix-Song-13.mp3", "$SOUNDHELIX/SoundHelix-Song-14.mp3") }
    "3"  = @{ Name = "Flowing River";       Emoji = "🌊";  Tracks = @("$NOCTUNE/river.mp3", "$SOUNDHELIX/SoundHelix-Song-11.mp3", "$SOUNDHELIX/SoundHelix-Song-15.mp3", "$SOUNDHELIX/SoundHelix-Song-16.mp3") }
    "4"  = @{ Name = "Singing Birds";      Emoji = "🐦";  Tracks = @("$NOCTUNE/night.mp3", "$SOUNDHELIX/SoundHelix-Song-4.mp3", "$SOUNDHELIX/SoundHelix-Song-8.mp3") }
    "5"  = @{ Name = "Thunder Storm";      Emoji = "⛈️";  Tracks = @("$NOCTUNE/thunder.mp3", "$SOUNDHELIX/SoundHelix-Song-11.mp3", "$SOUNDHELIX/SoundHelix-Song-15.mp3") }
    "6"  = @{ Name = "Howling Wind";       Emoji = "💨";  Tracks = @("$NOCTUNE/wind.mp3", "$SOUNDHELIX/SoundHelix-Song-12.mp3", "$SOUNDHELIX/SoundHelix-Song-16.mp3") }
    "7"  = @{ Name = "Campfire";           Emoji = "🏕️";  Tracks = @("$NOCTUNE/campfire.mp3", "$SOUNDHELIX/SoundHelix-Song-10.mp3", "$SOUNDHELIX/SoundHelix-Song-13.mp3") }
    "8"  = @{ Name = "Train Journey";      Emoji = "🚂";  Tracks = @("$NOCTUNE/train.mp3", "$SOUNDHELIX/SoundHelix-Song-14.mp3", "$SOUNDHELIX/SoundHelix-Song-15.mp3") }
    "9"  = @{ Name = "Café Chatter";       Emoji = "☕";  Tracks = @("$SOUNDHELIX/SoundHelix-Song-2.mp3", "$SOUNDHELIX/SoundHelix-Song-4.mp3", "$SOUNDHELIX/SoundHelix-Song-6.mp3", "$SOUNDHELIX/SoundHelix-Song-10.mp3") }
    "10" = @{ Name = "Lofi Focus";         Emoji = "🎧";  Tracks = @("$SOUNDHELIX/SoundHelix-Song-1.mp3", "$SOUNDHELIX/SoundHelix-Song-5.mp3", "$SOUNDHELIX/SoundHelix-Song-9.mp3", "$SOUNDHELIX/SoundHelix-Song-13.mp3", "$SOUNDHELIX/SoundHelix-Song-15.mp3") }
    "11" = @{ Name = "Deep Focus Piano";   Emoji = "🎹";  Tracks = @("$SOUNDHELIX/SoundHelix-Song-3.mp3", "$SOUNDHELIX/SoundHelix-Song-7.mp3", "$SOUNDHELIX/SoundHelix-Song-10.mp3", "$SOUNDHELIX/SoundHelix-Song-14.mp3", "$SOUNDHELIX/SoundHelix-Song-16.mp3") }
    "12" = @{ Name = "White Noise Loop";   Emoji = "📻";  Tracks = @("$SOUNDHELIX/SoundHelix-Song-11.mp3", "$SOUNDHELIX/SoundHelix-Song-12.mp3") }
    "13" = @{ Name = "Claude FM";          Emoji = "🤖";  Tracks = @("$SOUNDHELIX/SoundHelix-Song-1.mp3", "$SOUNDHELIX/SoundHelix-Song-4.mp3", "$SOUNDHELIX/SoundHelix-Song-9.mp3") }
}

# ─── Player State initialization ───
$players = @{}
$currentTrackIdx = @{}
$channelVolumes = @{} # Local volume scale 0-100
$isPlaying = @{}
$masterVolume = 80 # Global volume scale 0-100

foreach ($key in $trackLibrary.Keys) {
    $players[$key] = New-Object System.Windows.Media.MediaPlayer
    $currentTrackIdx[$key] = 0
    $channelVolumes[$key] = 50
    $isPlaying[$key] = $false
    
    # Load initial source
    $initialUrl = $trackLibrary[$key].Tracks[0]
    $players[$key].Open((New-Object System.Uri($initialUrl)))
}

# Helper to calculate and set player volume
function Set-PlayerVolume($key) {
    # .NET MediaPlayer volume takes values from 0.0 to 1.0
    $scaledVolume = ($channelVolumes[$key] / 100) * ($masterVolume / 100)
    $players[$key].Volume = $scaledVolume
}

# Helper to stop all
function Stop-All() {
    foreach ($key in $trackLibrary.Keys) {
        $players[$key].Stop()
        $isPlaying[$key] = $false
    }
}

# Easter Egg spoken greeting on start
try {
    $synthCmd = "Add-Type -AssemblyName System.Speech; (New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('ZEN AMBIATOR environment initialized. System ready.')"
    powershell -WindowStyle Hidden -Command $synthCmd
} catch {}

# ─── Main Interface Loop ───
$running = $true
while ($running) {
    Clear-Host
    
    # Draw futuristic ASCII and HUD header
    Write-Host " ══════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "      _____  ______ _   _                 __  __ _____ _    _ _____ " -ForegroundColor Cyan
    Write-Host "     |__  / |  ____| \ | |   /\   |\/|   |  \/  |_   _\ \  / |  ___|" -ForegroundColor Cyan
    Write-Host "       / /  | |__  |  \| |  /  \  |  |   | \  / | | |  \ \/ /| |__  " -ForegroundColor Magenta
    Write-Host "      / /_  |  __| | . ` | / /\ \ |  |   | |\/| | | |   \  / |  __| " -ForegroundColor Magenta
    Write-Host "     /____| |____|_|\_|_|/_/    \_|  |   |_|  |_|_____|  \/  |____| " -ForegroundColor Purple
    Write-Host " ══════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  SYS_LINK // OS_HUD_V2.1                     MASTER_GAIN // $masterVolume%" -ForegroundColor DarkCyan
    Write-Host " ══════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

    # Print Category sections
    $categories = @(
        @{ Header = "🌿 Nature";  Keys = @("1", "2", "3", "4") },
        @{ Header = "⚡ Weather"; Keys = @("5", "6") },
        @{ Header = "🔥 Cozy";    Keys = @("7", "8", "9") },
        @{ Header = "🎵 Music";   Keys = @("10", "11", "13", "12") }
    )

    foreach ($cat in $categories) {
        Write-Host "  [ // $($cat.Header) ]" -ForegroundColor Yellow
        foreach ($key in $cat.Keys) {
            $ch = $trackLibrary[$key]
            $status = "MUTED"
            $statusColor = "DarkGray"
            if ($isPlaying[$key]) {
                $status = "ACTIVE"
                $statusColor = "Cyan"
            }
            
            $trackNum = ($currentTrackIdx[$key] + 1).ToString().PadLeft(2, '0')
            $trackTotal = $ch.Tracks.Count.ToString().PadLeft(2, '0')
            
            $volPct = $channelVolumes[$key]
            $barCount = [int]($volPct / 10)
            $progressBar = ("=" * $barCount) + ("-" * (10 - $barCount))
            
            # Print row with alignment
            Write-Host "    [$($key.PadLeft(2))] $($ch.Emoji) $($ch.Name.PadRight(18)) " -NoNewline -ForegroundColor White
            Write-Host "TRACK_LINK // SYS_${trackNum}_${trackTotal} " -NoNewline -ForegroundColor DarkCyan
            Write-Host "[$progressBar] " -NoNewline -ForegroundColor Gray
            Write-Host "$($volPct.ToString().PadLeft(3))% " -NoNewline -ForegroundColor Gray
            Write-Host "[$status]" -ForegroundColor $statusColor
        }
        Write-Host ""
    }

    Write-Host " ══════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  COMMANDS: [Num] Toggle Play  |  s [Num] Skip  |  v [Num] [Val]" -ForegroundColor White
    Write-Host "            mv [Val] Master    |  m Mute All    |  q Quit" -ForegroundColor White
    Write-Host " ══════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    
    # Read user input asynchronously or with prompt
    $input = Read-Host "  ENTER COMMAND "
    $parts = $input.Trim().Split(" ")
    $cmd = $parts[0].ToLower()

    if ($cmd -eq "q" -or $cmd -eq "exit") {
        Stop-All
        $running = $false
    }
    elseif ($cmd -eq "m") {
        Stop-All
    }
    elseif ($cmd -eq "mv") {
        if ($parts.Length -gt 1) {
            $newVal = 0
            if ([int]::TryParse($parts[1], [ref]$newVal)) {
                $masterVolume = [Math]::Max(0, [Math]::Min(100, $newVal))
                # Update all active players
                foreach ($k in $trackLibrary.Keys) {
                    Set-PlayerVolume $k
                }
            }
        }
    }
    elseif ($cmd -eq "s") {
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
    elseif ($cmd -eq "v") {
        if ($parts.Length -gt 2) {
            $targetKey = $parts[1]
            $newVal = 0
            if ($trackLibrary.ContainsKey($targetKey) -and [int]::TryParse($parts[2], [ref]$newVal)) {
                $channelVolumes[$targetKey] = [Math]::Max(0, [Math]::Min(100, $newVal))
                Set-PlayerVolume $targetKey
            }
        }
    }
    elseif ($trackLibrary.ContainsKey($cmd)) {
        # Toggle play/pause
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

# Cleanup on exit
Stop-All
foreach ($key in $players.Keys) {
    $players[$key].Close()
}
