#!/usr/bin/env zsh
# ══════════════════════════════════════════════════════════════════════════════
#                     ZEN_AMBIATOR // OS_HUD_V2.1 (zsh Mixer)
# ══════════════════════════════════════════════════════════════════════════════
# Plays and mixes background ambient sounds from your terminal.
# Requires: mpv (for audio playback)
#
# Usage:  chmod +x zen-ambiator.zsh && ./zen-ambiator.zsh
# ══════════════════════════════════════════════════════════════════════════════

# ─── Check dependency ───
if ! command -v mpv &>/dev/null; then
  printf '\033[31mERROR: mpv not found. Install mpv first:\033[0m\n'
  printf '  macOS:  brew install mpv\n'
  printf '  Linux:  apt install mpv  |  pacman -S mpv\n'
  printf '  WSL:    sudo apt install mpv\n'
  exit 1
fi

# ─── Configuration & Track Library ───
NOCTUNE="https://raw.githubusercontent.com/karthiknvd/noctune/main/sounds"
SOUNDHELIX="https://www.soundhelix.com/examples/mp3"

# Channel keys (1-9, 1-indexed to match zsh array conventions)
keys=(1 2 3 4 5 6 7 8 9)

# Parallel arrays indexed by key (position 1 = key 1, etc.)
names=(
  "Heavy Rain"
  "Thunder Storm"
  "Train Journey"
  "Café Chatter"
  "Lofi Focus"
  "Deep Focus Piano"
  "Claude FM"
  "Lofi Radio Live"
  "White Noise"
)

emojis=(
  "🌧️" "⛈️" "🚂" "☕" "🎧" "🎹" "🤖" "📡" "📻"
)

# Track URLs — space-separated per channel
tracks_list=(
  "$NOCTUNE/rain.mp3 $SOUNDHELIX/SoundHelix-Song-6.mp3 $SOUNDHELIX/SoundHelix-Song-12.mp3 $SOUNDHELIX/SoundHelix-Song-16.mp3 https://stream.zeno.fm/f3t72887vxhvv"
  "$NOCTUNE/thunder.mp3 $SOUNDHELIX/SoundHelix-Song-11.mp3 $SOUNDHELIX/SoundHelix-Song-15.mp3 https://stream.zeno.fm/f3t72887vxhvv"
  "$NOCTUNE/train.mp3 $SOUNDHELIX/SoundHelix-Song-14.mp3 $SOUNDHELIX/SoundHelix-Song-15.mp3 https://stream.zeno.fm/096t61gh32zuv"
  "$SOUNDHELIX/SoundHelix-Song-2.mp3 $SOUNDHELIX/SoundHelix-Song-4.mp3 $SOUNDHELIX/SoundHelix-Song-6.mp3 $SOUNDHELIX/SoundHelix-Song-10.mp3 https://stream.zeno.fm/6szg7vzv32zuv"
  "$SOUNDHELIX/SoundHelix-Song-1.mp3 $SOUNDHELIX/SoundHelix-Song-5.mp3 $SOUNDHELIX/SoundHelix-Song-9.mp3 $SOUNDHELIX/SoundHelix-Song-13.mp3 $SOUNDHELIX/SoundHelix-Song-15.mp3 https://streams.fluxfm.de/Chillhop/mp3-128/"
  "$SOUNDHELIX/SoundHelix-Song-3.mp3 $SOUNDHELIX/SoundHelix-Song-7.mp3 $SOUNDHELIX/SoundHelix-Song-10.mp3 $SOUNDHELIX/SoundHelix-Song-14.mp3 $SOUNDHELIX/SoundHelix-Song-16.mp3 https://stream.zeno.fm/cg1t3u6h32zuv"
  "$SOUNDHELIX/SoundHelix-Song-1.mp3 $SOUNDHELIX/SoundHelix-Song-4.mp3 $SOUNDHELIX/SoundHelix-Song-9.mp3 https://streams.fluxfm.de/Chillhop/mp3-128/"
  "https://streams.fluxfm.de/Chillhop/mp3-128/"
  "$SOUNDHELIX/SoundHelix-Song-11.mp3 $SOUNDHELIX/SoundHelix-Song-12.mp3"
)

# ─── Player State ───
typeset -A pids          # mpv PID per channel key
typeset -A current_idx   # current track index per channel key
typeset -A playing       # is channel active?
master_volume=80          # 0-100

# ─── Helpers ───
get_tracks() {
  local key=$1
  echo "${tracks_list[$key]}"
}

get_track_count() {
  local tracks=(${(s: :)tracks_list[$1]})
  echo $#tracks
}

get_current_url() {
  local key=$1
  local tracks=(${(s: :)tracks_list[$key]})
  local idx=${current_idx[$key]:-0}
  echo "$tracks[$((idx + 1))]"
}

# ─── Player control functions ───
start_channel() {
  local key=$1
  local url=$(get_current_url $key)
  local logfile="/tmp/zen-ambiator-$key.log"

  # Kill existing process if any
  stop_channel $key

  mpv --no-video --volume=$master_volume --really-quiet --no-terminal \
    "$url" &>/dev/null &
  pids[$key]=$!
  playing[$key]="yes"
}

stop_channel() {
  local key=$1
  if [[ -n "${pids[$key]}" ]] && kill -0 "${pids[$key]}" 2>/dev/null; then
    kill "${pids[$key]}" 2>/dev/null
    wait "${pids[$key]}" 2>/dev/null
  fi
  pids[$key]=""
  playing[$key]="no"
}

stop_all() {
  for key in $keys; do
    stop_channel $key
  done
}

restart_channel() {
  local key=$1
  if [[ "${playing[$key]}" == "yes" ]]; then
    stop_channel $key
    start_channel $key
  fi
}

# ─── Skip track ───
skip_track() {
  local key=$1
  local tracks=(${(s: :)tracks_list[$key]})
  local count=$#tracks
  # Single-track channels can't skip
  if (( count <= 1 )); then
    # Restart current stream
    restart_channel $key
    return
  fi

  local idx=${current_idx[$key]:-0}
  idx=$(( (idx + 1) % count ))
  current_idx[$key]=$idx

  if [[ "${playing[$key]}" == "yes" ]]; then
    stop_channel $key
    start_channel $key
  fi
}

# ─── Toggle Play/Pause ───
toggle_play() {
  local key=$1
  if [[ "${playing[$key]}" == "yes" ]]; then
    stop_channel $key
  else
    start_channel $key
  fi
}

# ─── Master Volume ───
change_master_volume() {
  local val=$1
  # Clamp 0-100
  if (( val < 0 )); then val=0; fi
  if (( val > 100 )); then val=100; fi
  master_volume=$val
  # Restart all active channels with new volume
  for key in $keys; do
    if [[ "${playing[$key]}" == "yes" ]]; then
      stop_channel $key
      start_channel $key
    fi
  done
}

# ─── Info text for display ───
get_info_text() {
  local key=$1
  local tracks=(${(s: :)tracks_list[$key]})
  local count=$#tracks
  local idx=${current_idx[$key]:-0}

  # Key 8 = Lofi Radio Live (single stream)
  if [[ "$key" == "8" ]]; then
    printf "SYS_LINK // 24/7_STREAM    "
  elif (( idx == count - 1 )); then
    printf "SYS_LINK // 24/7_RADIO_LIVE"
  else
    local tn=$((idx + 1))
    local tt=$((count - 1))
    printf "TRACK_LINK // SYS_%02d_%02d " "$tn" "$tt"
  fi
}

# ─── ANSI Colors ───
NC="\033[0m"
CYAN="\033[36m"
MAGENTA="\033[35m"
PURPLE="\033[34m"
DARKCYAN="\033[36m"
YELLOW="\033[33m"
WHITE="\033[37m"
GRAY="\033[90m"
RED="\033[31m"
GREEN="\033[32m"
BOLD="\033[1m"

# ─── Cleanup handler ───
cleanup() {
  printf "\n${CYAN}Shutting down all channels...${NC}\n"
  stop_all
  exit 0
}
trap cleanup SIGINT SIGTERM EXIT

# ─── Display ───
draw_interface() {
  # ANSI clear screen and home cursor
  printf "\033[2J\033[H"

  # Header
  printf "${CYAN} ══════════════════════════════════════════════════════════════════${NC}\n"
  printf "${CYAN}      _____  ______ _   _                 __  __ _____ _    _ _____ ${NC}\n"
  printf "${CYAN}     |__  / |  ____| \ | |   /\   |\/|   |  \/  |_   _\ \  / |  ___|${NC}\n"
  printf "${MAGENTA}       / /  | |__  |  \| |  /  \  |  |   | \  / | | |  \ \/ /| |__  ${NC}\n"
  printf "${MAGENTA}      / /_  |  __| | . \` | / /\ \ |  |   | |\/| | | |   \  / |  __| ${NC}\n"
  printf "${PURPLE}     /____| |____|_|\_\_|/_/    \_|  |   |_|  |_|_____|  \/  |____| ${NC}\n"
  printf "${CYAN} ══════════════════════════════════════════════════════════════════${NC}\n"
  printf "${DARKCYAN}  SYS_LINK // OS_HUD_V2.1                     MASTER_GAIN // ${master_volume}%${NC}\n"
  printf "${CYAN} ══════════════════════════════════════════════════════════════════${NC}\n"

  # Categories
  local nature=(1)
  local weather=(2)
  local cozy=(3 4)
  local music=(5 6 7 8 9)

  _draw_category "🌿 Nature"  $nature
  _draw_category "⚡ Weather" $weather
  _draw_category "🔥 Cozy"    $cozy
  _draw_category "🎵 Music"   $music

  # Footer
  printf "${CYAN} ══════════════════════════════════════════════════════════════════${NC}\n"
  printf "${WHITE}  COMMANDS: [Num] Toggle Play  |  s [Num] Skip  |  mv [Val] Master${NC}\n"
  printf "${WHITE}            m Mute All          |  q Quit${NC}\n"
  printf "${CYAN} ══════════════════════════════════════════════════════════════════${NC}\n"
}

_draw_category() {
  local header=$1; shift
  local -a cat_keys=($@)

  printf "  ${YELLOW}[ // $header ]${NC}\n"
  for key in $cat_keys; do
    local name="${names[$key]}"
    local emoji="${emojis[$key]}"
    local status="${playing[$key]}"
    local info=$(get_info_text $key)

    if [[ "$status" == "yes" ]]; then
      printf "    ${WHITE}[%2s]${NC} ${WHITE}%s${NC} ${WHITE}%-18s${NC} " "$key" "$emoji" "$name"
      printf "${DARKCYAN}%s${NC} " "$info"
      printf "${GREEN}[ACTIVE]${NC}\n"
    else
      printf "    ${WHITE}[%2s]${NC} %s %-18s " "$key" "$emoji" "$name"
      printf "${DARKCYAN}%s${NC} " "$info"
      printf "${GRAY}[MUTED]${NC}\n"
    fi
  done
  printf "\n"
}

# ─── Initialize ───
printf "${CYAN}Initializing ZEN AMBIATOR...${NC}\n"
for key in $keys; do
  current_idx[$key]=0
  playing[$key]="no"
  pids[$key]=""
done

# ══════════════════════════════════════════════════════════════════════════════
# ─── Main Loop ───
# ══════════════════════════════════════════════════════════════════════════════
while true; do
  draw_interface

  # Read command
  printf "  ENTER COMMAND "
  read -r input

  # Parse
  local parts=(${(s: :)input})
  local cmd="${parts[1]}"

  case "$cmd" in
    q|exit)
      printf "${RED}Shutting down...${NC}\n"
      stop_all
      break
      ;;
    m)
      stop_all
      ;;
    mv)
      if (( $#parts >= 2 )); then
        local val="${parts[2]}"
        if [[ "$val" =~ ^[0-9]+$ ]]; then
          change_master_volume $val
        fi
      fi
      ;;
    s)
      if (( $#parts >= 2 )); then
        local target="${parts[2]}"
        if (( target >= 1 && target <= 9 )); then
          skip_track $target
        fi
      fi
      ;;
    [1-9])
      toggle_play $cmd
      ;;
    *)
      # Unknown command — just redraw
      ;;
  esac
done
