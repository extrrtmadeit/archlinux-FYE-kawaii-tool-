#!/usr/bin/env bash
set -e

# Installs/updates ~/.local/bin/fye with a bigger kawaii + cyber feature set
# Includes optional Discord/Telegram helper actions via webhook/bot API.

mkdir -p /home/extort/.fye/sfx /home/extort/.fye

cat > /home/extort/.local/bin/fye <<'EOF'
#!/usr/bin/env bash
set -e

CFG_DIR="$HOME/.fye"
CFG_FILE="$CFG_DIR/config.env"
SFX_DIR="$CFG_DIR/sfx"
mkdir -p "$CFG_DIR" "$SFX_DIR"

load_cfg() { [ -f "$CFG_FILE" ] && source "$CFG_FILE" || true; }
save_cfg_line() {
  local key="$1" val="$2"
  touch "$CFG_FILE"
  if grep -q "^${key}=" "$CFG_FILE"; then
    sed -i "s|^${key}=.*|${key}='${val}'|" "$CFG_FILE"
  else
    echo "${key}='${val}'" >> "$CFG_FILE"
  fi
}

play_sfx() {
  local kind="$1" file=""
  case "$kind" in
    select) file="$SFX_DIR/select.wav" ;;
    kawaii) file="$SFX_DIR/kawaii.wav" ;;
    error) file="$SFX_DIR/error.wav" ;;
  esac
  if [ -f "$file" ]; then
    if command -v paplay >/dev/null 2>&1; then paplay "$file" >/dev/null 2>&1 || true
    elif command -v aplay >/dev/null 2>&1; then aplay -q "$file" >/dev/null 2>&1 || true
    elif command -v ffplay >/dev/null 2>&1; then ffplay -nodisp -autoexit -loglevel quiet "$file" >/dev/null 2>&1 || true
    else printf '\a'
    fi
  else
    printf '\a'
  fi
}

header() {
  clear
  printf "\e[38;5;45m╔════════════════════════════════════════════════════════════════════╗\e[0m\n"
  printf "\e[38;5;45m║\e[0m   \e[38;5;99mF Y E   U L T I M A T E\e[0m   \e[38;5;51mKAWAII • CYBER • OPS\e[0m   \e[38;5;45m║\e[0m\n"
  printf "\e[38;5;45m╚════════════════════════════════════════════════════════════════════╝\e[0m\n\n"
}

pause(){ read -rp "Press Enter to continue..." _; }
run(){ eval "$1"; }

mk_sfx_local() {
python3 - <<'PY'
import os, wave, struct, math
home=os.path.expanduser('~')
out=os.path.join(home,'.fye','sfx')
os.makedirs(out,exist_ok=True)

def tone(path, seq, rate=44100):
    data=[]
    for hz,dur,vol in seq:
        n=int(rate*dur)
        for i in range(n):
            t=i/rate
            s=int(32767*vol*math.sin(2*math.pi*hz*t))
            data.append(s)
    with wave.open(path,'w') as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(rate)
        w.writeframes(b''.join(struct.pack('<h',x) for x in data))

tone(os.path.join(out,'select.wav'), [(880,0.05,0.35),(1320,0.05,0.30)])
tone(os.path.join(out,'kawaii.wav'), [(1046,0.06,0.35),(1318,0.06,0.35),(1567,0.08,0.30)])
tone(os.path.join(out,'error.wav'), [(220,0.08,0.35),(180,0.08,0.30)])
print('ok')
PY
}

fetch_online_sfx() {
  mkdir -p "$SFX_DIR"
  # Best-effort free/public URLs; failures are ignored.
  curl -L --fail -o "$SFX_DIR/select.wav" "https://raw.githubusercontent.com/terkelg/awesome-creative-coding/master/audio/click.wav" >/dev/null 2>&1 || true
  curl -L --fail -o "$SFX_DIR/kawaii.wav" "https://raw.githubusercontent.com/terkelg/awesome-creative-coding/master/audio/pop.wav" >/dev/null 2>&1 || true
  curl -L --fail -o "$SFX_DIR/error.wav" "https://raw.githubusercontent.com/terkelg/awesome-creative-coding/master/audio/error.wav" >/dev/null 2>&1 || true
}

discord_send() {
  load_cfg
  if [ -z "${DISCORD_WEBHOOK_URL:-}" ]; then
    echo "No DISCORD_WEBHOOK_URL set. Use option 21 first."
    return 1
  fi
  read -rp "Message for Discord webhook: " msg
  curl -s -X POST -H 'Content-Type: application/json' -d "{\"content\":\"$msg\"}" "$DISCORD_WEBHOOK_URL" >/dev/null && echo "Sent."
}

telegram_send() {
  load_cfg
  if [ -z "${TELEGRAM_BOT_TOKEN:-}" ] || [ -z "${TELEGRAM_CHAT_ID:-}" ]; then
    echo "Missing TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID. Use options 22/23 first."
    return 1
  fi
  read -rp "Message for Telegram: " msg
  curl -s "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d chat_id="$TELEGRAM_CHAT_ID" -d text="$msg" >/dev/null && echo "Sent."
}

while true; do
  header
  cat <<MENU
[STYLE/ANIMATIONS]
 1) Cyber Banner
 2) Matrix Rain
 3) Kawaii Mode
 4) Nyan Cat
 5) Glow Fetch
 6) Pipes Animation
 7) Aqua (safe)
 8) Retro Train (sl)

[TOOLS]
 9) Hackmenu
10) Nmap Localhost Scan
11) Nmap LAN Sweep
12) SQLMap Help
13) Bandwidth by Process
14) System Monitor (btop)
15) Route Health (mtr)
16) File Explorer (ranger)
17) Disk Usage (dust+duf)
18) JSON Pretty demo (jq)
19) Terminal Recorder (asciinema)
20) Repo Flex (onefetch)

[INTEGRATIONS]
21) Set Discord Webhook URL
22) Set Telegram Bot Token
23) Set Telegram Chat ID
24) Send Discord Message
25) Send Telegram Message
26) Open Discord Web
27) Open Telegram Web

[SFX/THEME]
28) Generate local SFX (recommended)
29) Try fetch online SFX
30) Toggle startup banner on/off
31) Print config status

 0) Exit
MENU
  echo
  read -rp "Choose option: " opt
  play_sfx select

  case "$opt" in
    1) header; figlet EXTORT | lolcat; pause ;;
    2) cmatrix -ab -u 4 ;;
    3) play_sfx kawaii; header; echo "(づ｡◕‿‿◕｡)づ" | lolcat; (ponysay "kawaii mode ✨" 2>/dev/null || cowsay "kawaii mode ✨" | lolcat); pause ;;
    4) nyancat ;;
    5) header; (hyfetch 2>/dev/null || fastfetch) | lolcat; pause ;;
    6) ~/.local/bin/pipes ;;
    7) header; figlet AQUA | lolcat; pause ;;
    8) sl ;;

    9) hackmenu ;;
    10) header; nmap -sV 127.0.0.1; pause ;;
    11) header; read -rp "LAN base (ex 192.168.1): " base; nmap -sn "${base}.0/24"; pause ;;
    12) header; sqlmap --help | less ;;
    13) sudo bandwhich ;;
    14) btop ;;
    15) mtr -rw -c 20 1.1.1.1; pause ;;
    16) ranger ;;
    17) header; echo "--- dust ---"; dust; echo; echo "--- duf ---"; duf; pause ;;
    18) header; echo '{"fye":"ultimate","status":"ok"}' | jq .; pause ;;
    19) header; echo "Recording... Ctrl+D to stop."; asciinema rec ;;
    20) header; onefetch 2>/dev/null || echo "Run inside a git repo"; pause ;;

    21) read -rp "Discord webhook URL: " v; save_cfg_line DISCORD_WEBHOOK_URL "$v"; echo saved; pause ;;
    22) read -rp "Telegram bot token: " v; save_cfg_line TELEGRAM_BOT_TOKEN "$v"; echo saved; pause ;;
    23) read -rp "Telegram chat id: " v; save_cfg_line TELEGRAM_CHAT_ID "$v"; echo saved; pause ;;
    24) header; discord_send || true; pause ;;
    25) header; telegram_send || true; pause ;;
    26) xdg-open https://discord.com/channels >/dev/null 2>&1 || true ;;
    27) xdg-open https://web.telegram.org >/dev/null 2>&1 || true ;;

    28) header; mk_sfx_local; echo "Local SFX generated in $SFX_DIR"; pause ;;
    29) header; fetch_online_sfx; echo "Online SFX fetch attempted."; pause ;;
    30)
      Z="$HOME/.zshrc"
      if grep -q "extort_banner" "$Z"; then
        sed -i '/extort_banner/d' "$Z"
        echo "Startup banner OFF"
      else
        echo '# extort_banner' >> "$Z"
        echo '[ -x "$HOME/.extort_banner.sh" ] && $HOME/.extort_banner.sh' >> "$Z"
        echo "Startup banner ON"
      fi
      pause
      ;;
    31) header; load_cfg; printf "DISCORD_WEBHOOK_URL=%s\nTELEGRAM_BOT_TOKEN=%s\nTELEGRAM_CHAT_ID=%s\n" "${DISCORD_WEBHOOK_URL:+set}" "${TELEGRAM_BOT_TOKEN:+set}" "${TELEGRAM_CHAT_ID:+set}"; pause ;;

    0) break ;;
    *) play_sfx error; echo "invalid"; sleep 1 ;;
  esac
done
EOF

chmod +x /home/extort/.local/bin/fye

# install helper scripts if missing
if [ ! -f /home/extort/.local/bin/pipes ]; then
cat > /home/extort/.local/bin/pipes <<'EOF'
#!/usr/bin/env bash
chars='┃━┏┓┗┛┣┫┳┻╋'
while true; do
  cols=$(tput cols 2>/dev/null || echo 80)
  line=""
  for ((i=0;i<cols;i++)); do
    idx=$((RANDOM % ${#chars}))
    line+="${chars:$idx:1}"
  done
  printf "\e[38;5;$((RANDOM%200+20))m%s\e[0m\n" "$line"
  sleep 0.04
done
EOF
chmod +x /home/extort/.local/bin/pipes
fi

Z=/home/extort/.zshrc
touch "$Z"
grep -q '\.local/bin' "$Z" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$Z"
grep -q 'alias fye=' "$Z" || echo "alias fye='~/.local/bin/fye'" >> "$Z"

chown -R extort:extort /home/extort/.local /home/extort/.fye /home/extort/.zshrc

echo "done"
