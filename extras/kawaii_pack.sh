#!/usr/bin/env bash
set -e
mkdir -p /home/extort/.local/bin

cat > /home/extort/.local/bin/kawaii <<'EOF'
#!/usr/bin/env bash
clear
echo "(づ｡◕‿‿◕｡)づ KAWAII MODE" | lolcat
echo
fortune | lolcat
echo
if command -v ponysay >/dev/null 2>&1; then
  ponysay "you got this extort ✨"
else
  cowsay "you got this extort ✨" | lolcat
fi
echo
asciiquarium
EOF
chmod +x /home/extort/.local/bin/kawaii

cat > /home/extort/.local/bin/nyanloop <<'EOF'
#!/usr/bin/env bash
while true; do
  nyancat
  sleep 1
done
EOF
chmod +x /home/extort/.local/bin/nyanloop

Z=/home/extort/.zshrc
touch "$Z"
grep -q 'alias kawaii=' "$Z" || echo "alias kawaii='~/.local/bin/kawaii'" >> "$Z"
grep -q 'alias nyanloop=' "$Z" || echo "alias nyanloop='~/.local/bin/nyanloop'" >> "$Z"
grep -q 'alias pony=' "$Z" || echo "alias pony='ponysay'" >> "$Z"
grep -q 'alias aqua=' "$Z" || echo "alias aqua='asciiquarium'" >> "$Z"

chown -R extort:extort /home/extort/.local
chown extort:extort "$Z"
echo done
