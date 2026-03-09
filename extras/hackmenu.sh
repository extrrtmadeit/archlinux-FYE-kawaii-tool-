#!/usr/bin/env bash
set -e

# Legal-only starter menu (self/authorized targets only)

while true; do
  clear
  echo "========================================="
  echo "   EXTORT LEGAL SECURITY TOOL MENU"
  echo "========================================="
  echo "1) Quick local service scan (127.0.0.1)"
  echo "2) Ping sweep your LAN (/24)"
  echo "3) Port scan custom target"
  echo "4) Show network interfaces"
  echo "5) Bandwidth monitor (bandwhich)"
  echo "6) SQLMap help"
  echo "0) Exit"
  echo "-----------------------------------------"
  read -rp "Choose: " choice

  case "$choice" in
    1)
      echo "\n[+] nmap -sV 127.0.0.1\n"
      nmap -sV 127.0.0.1
      ;;
    2)
      read -rp "Enter LAN base (example 192.168.1): " base
      if [[ ! "$base" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo "Invalid base format."
      else
        echo "\n[+] nmap -sn ${base}.0/24\n"
        nmap -sn "${base}.0/24"
      fi
      ;;
    3)
      read -rp "Target IP/host (authorized only): " target
      read -rp "Ports (example 1-1000 or 22,80,443): " ports
      [[ -z "$ports" ]] && ports="1-1000"
      echo "\n[+] nmap -sV -p $ports $target\n"
      nmap -sV -p "$ports" "$target"
      ;;
    4)
      echo "\n[+] ip a\n"
      ip a
      ;;
    5)
      echo "\n[+] Starting bandwhich (Ctrl+C to stop)\n"
      sudo bandwhich || true
      ;;
    6)
      sqlmap --help | less
      ;;
    0)
      echo "bye"
      exit 0
      ;;
    *)
      echo "Invalid choice"
      ;;
  esac

  echo ""
  read -rp "Press Enter to continue..." _
done
