#!/usr/bin/env bash
set -e

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
figlet EXTORT | lolcat
EOF
chmod +x /home/extort/.local/bin/kawaii

# remove fish alias (if present) and point aqua to harmless banner
Z=/home/extort/.zshrc
sed -i '/alias aqua=/d' "$Z"
echo "alias aqua='figlet AQUA | lolcat'" >> "$Z"
chown extort:extort "$Z"
chown -R extort:extort /home/extort/.local

echo done
