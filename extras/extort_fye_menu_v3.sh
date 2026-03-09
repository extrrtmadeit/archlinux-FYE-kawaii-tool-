#!/usr/bin/env bash
set -e

cat > /home/extort/.local/bin/fye <<'EOF'
#!/usr/bin/env bash
beep() { printf '\a'; }
header() {
  clear
  printf "\e[38;5;45m╔══════════════════════════════════════════════════════════════╗\e[0m\n"
  printf "\e[38;5;45m║\e[0m  \e[38;5;99mE X T O R T  F Y E  v3\e[0m  \e[38;5;51mCYBER OPS + ANIMATIONS\e[0m  \e[38;5;45m║\e[0m\n"
  printf "\e[38;5;45m╚══════════════════════════════════════════════════════════════╝\e[0m\n\n"
}
pause(){ read -rp "Press Enter to continue..." _; }

while true; do
  header
  echo "[STYLE / ANIMATIONS]"
  echo " 1) Cyber Banner"
  echo " 2) Matrix Rain"
  echo " 3) Kawaii Mode"
  echo " 4) Nyan Cat"
  echo " 5) Glow Fetch"
  echo " 6) Pipes Animation"
  echo ""
  echo "[USEFUL TOOLS]"
  echo " 7) Hackmenu"
  echo " 8) Nmap Localhost Service Scan"
  echo " 9) Nmap LAN Ping Sweep"
  echo "10) SQLMap Help"
  echo "11) Bandwidth by Process"
  echo "12) System Monitor (btop)"
  echo "13) Net Route Health (mtr to 1.1.1.1)"
  echo "14) File Explorer (ranger)"
  echo "15) Disk Usage (dust + duf)"
  echo "16) JSON Pretty (jq demo)"
  echo "17) Terminal Recorder (asciinema)"
  echo " 0) Exit"
  echo ""
  read -rp "Choose option: " opt
  beep

  case "$opt" in
    1) header; figlet EXTORT | lolcat; pause ;;
    2) cmatrix -ab -u 4 ;;
    3) header; echo "(づ｡◕‿‿◕｡)づ" | lolcat; ponysay "extort mode" 2>/dev/null || cowsay "extort mode" | lolcat; pause ;;
    4) nyancat ;;
    5) header; fastfetch | lolcat; pause ;;
    6) ~/.local/bin/pipes ;;
    7) hackmenu ;;
    8) header; nmap -sV 127.0.0.1; pause ;;
    9) header; read -rp "LAN base (ex: 192.168.1): " base; nmap -sn "${base}.0/24"; pause ;;
    10) header; sqlmap --help | less ;;
    11) sudo bandwhich ;;
    12) btop ;;
    13) mtr -rw -c 20 1.1.1.1; pause ;;
    14) ranger ;;
    15) header; echo "--- dust ---"; dust; echo "\n--- duf ---"; duf; pause ;;
    16) header; echo '{"tool":"jq","status":"working","vibe":"fye"}' | jq .; pause ;;
    17) header; echo "Recording started. Ctrl+D to stop."; asciinema rec ;;
    0) break ;;
    *) echo "invalid"; sleep 1 ;;
  esac
done
EOF

chmod +x /home/extort/.local/bin/fye
Z=/home/extort/.zshrc
grep -q "alias fye=" "$Z" || echo "alias fye='~/.local/bin/fye'" >> "$Z"
chown -R extort:extort /home/extort/.local /home/extort/.zshrc

echo done
