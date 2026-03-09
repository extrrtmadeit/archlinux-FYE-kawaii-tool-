#!/usr/bin/env bash
set -e

echo "[+] FYE v2 install starting..."

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed \
  zsh starship neovim fastfetch \
  cmatrix nyancat asciiquarium \
  btop ranger onefetch asciinema \
  nmap sqlmap mtr bandwhich \
  fortune-mod cowsay lolcat figlet toilet \
  dust duf jq yq ripgrep fd fzf zoxide lsd ttyper

for p in ponysay; do
  if pacman -Si "$p" >/dev/null 2>&1; then
    sudo pacman -S --noconfirm --needed "$p"
  fi
done

mkdir -p "$HOME/.local/bin"

# install from repo extras if present
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
for f in hackmenu.sh extort_fye_menu_v3.sh kawaii_pack.sh kawaii_pack_patch.sh extort_banner.sh drip_pack_v2.sh; do
  if [[ -f "$REPO_DIR/extras/$f" ]]; then
    cp "$REPO_DIR/extras/$f" "$HOME/.local/bin/${f%.sh}"
    chmod +x "$HOME/.local/bin/${f%.sh}"
  fi
done

# fallback custom scripts
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
chmod +x "$HOME/.local/bin/pipes"

# convenience wrappers
cat > "$HOME/.local/bin/hackmenu" <<'EOF'
#!/usr/bin/env bash
if command -v hackmenu >/dev/null 2>&1; then exec hackmenu "$@"; fi
nmap -sV 127.0.0.1
EOF
chmod +x "$HOME/.local/bin/hackmenu"

cat > "$HOME/.local/bin/fye" <<'EOF'
#!/usr/bin/env bash
if command -v extort_fye_menu_v3 >/dev/null 2>&1; then
  exec extort_fye_menu_v3
fi
clear
echo "FYE installed. Run: banner, matrix, nyan, hacktop"
EOF
chmod +x "$HOME/.local/bin/fye"

Z="$HOME/.zshrc"
touch "$Z"

grep -q '\.local/bin' "$Z" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$Z"
grep -q 'starship init zsh' "$Z" || echo 'eval "$(starship init zsh)"' >> "$Z"
grep -q 'zsh-autosuggestions' "$Z" || echo 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> "$Z"
grep -q 'zsh-syntax-highlighting' "$Z" || echo 'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> "$Z"
grep -q 'vivid generate' "$Z" || echo 'export LS_COLORS="$(vivid generate molokai)"' >> "$Z"

grep -q 'alias banner=' "$Z" || echo 'alias banner="figlet EXTORT | lolcat"' >> "$Z"
grep -q 'alias matrix=' "$Z" || echo 'alias matrix="cmatrix -ab -u 3"' >> "$Z"
grep -q 'alias nyan=' "$Z" || echo 'alias nyan="nyancat"' >> "$Z"
grep -q 'alias wisdom=' "$Z" || echo 'alias wisdom="fortune | lolcat"' >> "$Z"
grep -q 'alias hacktop=' "$Z" || echo 'alias hacktop="btop"' >> "$Z"
grep -q 'alias repo=' "$Z" || echo 'alias repo="onefetch"' >> "$Z"
grep -q 'alias kawaii=' "$Z" || echo 'alias kawaii="~/.local/bin/kawaii"' >> "$Z"
grep -q 'alias pipes=' "$Z" || echo 'alias pipes="~/.local/bin/pipes"' >> "$Z"
grep -q 'alias fye=' "$Z" || echo 'alias fye="~/.local/bin/fye"' >> "$Z"

echo "[+] FYE v2 complete"
echo "Run: source ~/.zshrc && fye"
