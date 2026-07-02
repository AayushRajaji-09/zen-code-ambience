#!/usr/bin/env zsh
# ══════════════════════════════════════════════════════════════════════════════
#  ZEN AMBIATOR — macOS Edition
#  Double-click this file to launch. Requires mpv.
#  Install mpv: brew install mpv
# ══════════════════════════════════════════════════════════════════════════════

# ─── Check dependency ───
if ! command -v mpv &>/dev/null; then
  echo ""
  echo "  mpv not found. Install it with:"
  echo "    brew install mpv"
  echo ""
  echo "  Or download from: https://mpv.io/installation/"
  echo ""
  read -r -p "  Press Enter to quit..."
  exit 1
fi

# ─── Track Library ───
NOCTUNE="https://raw.githubusercontent.com/karthiknvd/noctune/main/sounds"
SOUNDHELIX="https://www.soundhelix.com/examples/mp3"

keys=(1 2 3 4 5 6 7 8 9)

names=(
  "Heavy Rain"
  "Thunder Storm"
  "Train Journey"
  "Cafe Chatter"
  "Lofi Focus"
  "Deep Focus Piano"
  "Claude FM"
  "Lofi Radio Live"
  "White Noise"
)

categories=(
  "Nature"
  "Weather"
  "Cozy"
  "Cozy"
  "Music"
  "Music"
  "Music"
  "Music"
  "Music"
)

tracks_list=(
  "$NOCTUNE/rain.mp3 $SOUNDHELIX/SoundHelix-Song-6.mp3 $SOUNDHELIX/SoundHelix-Song-12.mp3 $SOUNDHELIX/SoundHelix-Song-16.mp3 $SOUNDHELIX/SoundHelix-Song-8.mp3"
  "$NOCTUNE/thunder.mp3 $SOUNDHELIX/SoundHelix-Song-11.mp3 $SOUNDHELIX/SoundHelix-Song-15.mp3 $SOUNDHELIX/SoundHelix-Song-7.mp3"
  "$NOCTUNE/train.mp3 $SOUNDHELIX/SoundHelix-Song-14.mp3 $SOUNDHELIX/SoundHelix-Song-15.mp3 $SOUNDHELIX/SoundHelix-Song-10.mp3"
  "$SOUNDHELIX/SoundHelix-Song-2.mp3 $SOUNDHELIX/SoundHelix-Song-4.mp3 $SOUNDHELIX/SoundHelix-Song-6.mp3 $SOUNDHELIX/SoundHelix-Song-10.mp3 $SOUNDHELIX/SoundHelix-Song-13.mp3"
  "$SOUNDHELIX/SoundHelix-Song-1.mp3 $SOUNDHELIX/SoundHelix-Song-5.mp3 $SOUNDHELIX/SoundHelix-Song-9.mp3 $SOUNDHELIX/SoundHelix-Song-13.mp3 $SOUNDHELIX/SoundHelix-Song-15.mp3"
  "$SOUNDHELIX/SoundHelix-Song-3.mp3 $SOUNDHELIX/SoundHelix-Song-7.mp3 $SOUNDHELIX/SoundHelix-Song-10.mp3 $SOUNDHELIX/SoundHelix-Song-14.mp3 $SOUNDHELIX/SoundHelix-Song-16.mp3 $SOUNDHELIX/SoundHelix-Song-8.mp3"
  "$SOUNDHELIX/SoundHelix-Song-1.mp3 $SOUNDHELIX/SoundHelix-Song-4.mp3 $SOUNDHELIX/SoundHelix-Song-9.mp3"
  "https://streams.fluxfm.de/Chillhop/mp3-128/"
  "$SOUNDHELIX/SoundHelix-Song-2.mp3 $SOUNDHELIX/SoundHelix-Song-11.mp3"
)

# ─── State ───
typeset -A pids
typeset -A current_idx
typeset -A playing
master_volume=80

# ─── Helpers ───
get_current_url() {
  local key=$1
  local tracks=(${(s: :)tracks_list[$key]})
  local idx=${current_idx[$key]:-0}
  echo "$tracks[$((idx + 1))]"
}

get_track_count() {
  local tracks=(${(s: :)tracks_list[$1]})
  echo $#tracks
}

# ─── Player ───
start_channel() {
  local key=$1
  local url=$(get_current_url $key)
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

skip_track() {
  local key=$1
  local tracks=(${(s: :)tracks_list[$key]})
  local count=$#tracks
  if (( count <= 1 )); then
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
  # macOS notification
  osascript -e "display notification \"$(get_current_url $key | sed 's|.*/||; s|%20| |g')\" with title \"${names[$key]}\" subtitle \"Track $((idx + 1))\""
}

restart_channel() {
  local key=$1
  if [[ "${playing[$key]}" == "yes" ]]; then
    stop_channel $key
    start_channel $key
  fi
}

toggle_play() {
  local key=$1
  if [[ "${playing[$key]}" == "yes" ]]; then
    stop_channel $key
  else
    start_channel $key
  fi
}

change_master_volume() {
  local val=$1
  if (( val < 0 )); then val=0; fi
  if (( val > 100 )); then val=100; fi
  master_volume=$val
  for key in $keys; do
    if [[ "${playing[$key]}" == "yes" ]]; then
      stop_channel $key
      start_channel $key
    fi
  done
}

get_track_label() {
  local key=$1
  local tracks=(${(s: :)tracks_list[$key]})
  local count=$#tracks
  local idx=${current_idx[$key]:-0}
  if (( key == 8 )); then
    echo "LIVE"
  elif (( idx == count - 1 )); then
    echo "RADIO"
  else
    printf "Track %02d/%02d" $((idx + 1)) $((count - 1))
  fi
}

# ─── Cleanup ───
cleanup() {
  printf "\n  Shutting down...\n"
  stop_all
  exit 0
}
trap cleanup SIGINT SIGTERM EXIT

# ─── Display ───
draw_interface() {
  printf "\033[2J\033[H"
  printf "\033[38;5;39m"
  printf "  ┌─────────────────────────────────────────────────────────────┐\n"
  printf "  │  Zen Ambience — macOS Edition                              │\n"
  printf "  │  Master Volume: %3d%%                                        │\n" "$master_volume"
  printf "  └─────────────────────────────────────────────────────────────┘\n"
  printf "\033[0m"

  local current_cat=""
  for key in $keys; do
    local cat="${categories[$key]}"
    if [[ "$cat" != "$current_cat" ]]; then
      current_cat="$cat"
      printf "\n  \033[38;5;245m%s\033[0m\n" "$cat"
    fi

    local name="${names[$key]}"
    local label=$(get_track_label $key)
    local icon=" "
    local status_color="\033[90m"
    local status_text="STOPPED"
    if [[ "${playing[$key]}" == "yes" ]]; then
      icon=">"
      status_color="\033[92m"
      status_text="PLAYING"
    fi

    printf "  %s  \033[1m[%s]\033[0m  %-20s %s  %s%s\033[0m  %s\n" \
      "$icon" "$key" "$name" "$label" "$status_color" "$status_text" "\033[0m"
  done

  printf "\n"
  printf "\033[38;5;245m"
  printf "  [1-9] Play/Pause  |  s[Num] Skip  |  mv[Val] Volume\n"
  printf "  m  Mute All       |  q  Quit\n"
  printf "\033[0m\n"
  printf "  > "
}

# ─── Init ───
for key in $keys; do
  current_idx[$key]=0
  playing[$key]="no"
  pids[$key]=""
done

# ─── Main Loop ───
while true; do
  draw_interface
  read -r input

  local parts=(${(s: :)input})
  local cmd="${parts[1]}"

  case "$cmd" in
    q|exit)
      printf "  Quitting...\n"
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
  esac
done
