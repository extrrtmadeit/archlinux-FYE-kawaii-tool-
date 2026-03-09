#!/usr/bin/env bash
set -e
mkdir -p /home/extort/.local/bin

cat > /home/extort/.local/bin/pipes <<'EOF'
#!/usr/bin/env bash
# tiny pipes-style animation
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

Z=/home/extort/.zshrc
touch "$Z"

grep -q '.local/bin' "$Z" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$Z"
grep -q 'alias nyan=' "$Z" || echo 'alias nyan="nyancat"' >> "$Z"
grep -q 'alias pipes=' "$Z" || echo 'alias pipes="~/.local/bin/pipes"' >> "$Z"
grep -q 'alias clock=' "$Z" || echo 'alias clock="watch -n 1 date"' >> "$Z"
grep -q 'alias drip=' "$Z" || cat >> "$Z" <<'EOF'
alias drip='clear; banner; echo; echo "commands: matrix | pipes | nyan | fish | hacktop | repo | wisdom" | lolcat'
EOF

chown -R extort:extort /home/extort/.local
chown extort:extort "$Z"
echo done
