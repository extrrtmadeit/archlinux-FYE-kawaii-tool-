#!/usr/bin/env bash
set -e

echo "[+] Installing FYE packages..."

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed \
  zsh starship cmatrix nyancat asciiquarium btop ranger onefetch asciinema \
  nmap sqlmap mtr bandwhich fortune-mod cowsay lolcat figlet toilet \
  dust duf jq yq ripgrep fd fzf zoxide fastfetch lsd neovim

# Optional packages
for p in ponysay; do
  if pacman -Si "$p" >/dev/null 2>&1; then
    sudo pacman -S --noconfirm --needed "$p"
  fi
done

mkdir -p "$HOME/.local/bin"

cat > "$HOME/.local/bin/pipes" <<'EOF'
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

cat > "$HOME/.local/bin/hackmenu" <<'EOF'
#!/usr/bin/env bash
set -e
while true; do
  clear
  echo "=== FYE LEGAL SECURITY MENU ==="
  echo "1) Localhost service scan"
  echo "2) LAN ping sweep"
  echo "3) Custom port scan"
  echo "4) Show interfaces"
  echo "5) SQLMap help"
  echo "0) Exit"
  read -rp "Choose: " c
  case "$c" in
    1) nmap -sV 127.0.0.1 ;;
    2) read -rp "LAN base (ex 192.168.1): " b; nmap -sn "${b}.0/24" ;;
    3) read -rp "Target: " t; read -rp "Ports (default 1-1000): " p; p=${p:-1-1000}; nmap -sV -p "$p" "$t" ;;
    4) ip a ;;
    5) sqlmap --help | less ;;
    0) exit 0 ;;
    *) echo invalid ;;
  esac
  read -rp "Enter to continue..." _
done
EOF

cat > "$HOME/.local/bin/kawaii" <<'EOF'
#!/usr/bin/env bash
clear
echo "(づ｡◕‿‿◕｡)づ KAWAII MODE" | lolcat
fortune | lolcat
if command -v ponysay >/dev/null 2>&1; then
  ponysay "FYE mode activated ✨"
else
  cowsay "FYE mode activated ✨" | lolcat
fi
EOF

cat > "$HOME/.local/bin/fye" <<'EOF'
#!/usr/bin/env bash
beep(){ printf '\a'; }
while true; do
  clear
  echo "╔════════════════════════════════════╗"
  echo "║        FYE (KAWAII) TOOL          ║"
  echo "╚════════════════════════════════════╝"
  echo
  echo "1) Banner"
  echo "2) Matrix"
  echo "3) Kawaii"
  echo "4) Nyan"
  echo "5) Glow Fetch"
  echo "6) Hackmenu"
  echo "7) btop"
  echo "8) ranger"
  echo "9) onefetch"
  echo "10) pipes"
  echo "0) Exit"
  read -rp "Choose: " opt
  beep
  case "$opt" in
    1) figlet EXTORT | lolcat ; read -rp "Enter..." _ ;;
    2) cmatrix -ab -u 4 ;;
    3) kawaii ; read -rp "Enter..." _ ;;
    4) nyancat ;;
    5) fastfetch | lolcat ; read -rp "Enter..." _ ;;
    6) hackmenu ;;
    7) btop ;;
    8) ranger ;;
    9) onefetch 2>/dev/null || echo "Run in a git repo"; read -rp "Enter..." _ ;;
    10) pipes ;;
    0) exit 0 ;;
  esac
done
EOF

chmod +x "$HOME/.local/bin/pipes" "$HOME/.local/bin/hackmenu" "$HOME/.local/bin/kawaii" "$HOME/.local/bin/fye"

Z="$HOME/.zshrc"
touch "$Z"

grep -q '\.local/bin' "$Z" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$Z"
grep -q 'starship init zsh' "$Z" || echo 'eval "$(starship init zsh)"' >> "$Z"
grep -q 'alias banner=' "$Z" || echo 'alias banner="figlet EXTORT | lolcat"' >> "$Z"
grep -q 'alias matrix=' "$Z" || echo 'alias matrix="cmatrix -ab -u 3"' >> "$Z"
grep -q 'alias nyan=' "$Z" || echo 'alias nyan="nyancat"' >> "$Z"
grep -q 'alias wisdom=' "$Z" || echo 'alias wisdom="fortune | lolcat"' >> "$Z"
grep -q 'alias hacktop=' "$Z" || echo 'alias hacktop="btop"' >> "$Z"
grep -q 'alias repo=' "$Z" || echo 'alias repo="onefetch"' >> "$Z"
grep -q 'alias drip=' "$Z" || echo 'alias drip="clear; banner; echo commands: fye matrix nyan kawaii hackmenu | lolcat"' >> "$Z"

echo "[+] Install complete. Run: source ~/.zshrc && fye"
