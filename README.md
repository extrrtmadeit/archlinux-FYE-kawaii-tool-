# FYE (Kawaii) Tool for Arch Linux

A flashy terminal toolkit for Arch Linux (great in WSL too):
- neon/cyber menu UI
- kawaii + hacker vibes
- animations + utility commands
- legal security helper shortcuts

> Built for fun + productivity. Use security tools only on systems you own or are authorized to test.

---

## Preview

- See live-style preview: [PREVIEW.md](./PREVIEW.md)

## Features

### 🎨 Style + Fun
- `fye` interactive menu (30+ options in Ultimate)
- Matrix rain
- Nyan cat
- Kawaii mode (ponysay/cowsay + colors)
- EXTORT banner
- random quote vibe (`wisdom`)
- custom terminal pipes animation

### 🔊 SFX
- local generated sound effects (all kawaii/chime style)
- optional online sound-effect fetch
- animated anime-style title shimmer in menu

### 🛠 Useful Utilities
- system monitor (`btop`)
- repo flex (`onefetch`)
- file explorer (`ranger`)
- disk usage (`dust`, `duf`)
- terminal recorder (`asciinema`)
- network route health (`mtr`)
- json formatter demo (`jq`)

### 🔐 Legal Security Helpers
- `hackmenu` launcher
- localhost scan shortcut
- LAN ping sweep shortcut
- SQLMap help shortcut

### 🌐 Integrations
- Discord webhook config + send message
- Telegram bot token/chat config + send message
- quick open Discord/Telegram web

---

## Requirements

- Arch Linux
- zsh (recommended)
- internet access for package installs

For WSL users: install Arch distro first, then run setup.

---

## Install (One-shot)

```bash
# clone or copy this repo first
cd FYE-kawaii-tool
chmod +x setup-v2.sh
./setup-v2.sh
```

Then restart terminal or run:
```bash
source ~/.zshrc
fye
```

> Legacy installer: `setup.sh` (kept for compatibility)

---

## Main Commands

- `fye` → opens full menu
- `hackmenu` → legal security helper menu
- `banner` → big EXTORT text
- `matrix` → matrix animation
- `nyan` → nyancat
- `pipes` → custom animated pipes
- `kawaii` → kawaii mode scene
- `wisdom` → colorful random quote
- `repo` → onefetch repo summary
- `hacktop` → btop monitor
- `drip` → quick vibe splash screen

---

## Setup Details (what `setup.sh` does)

1. Installs packages:
   - `zsh starship`
   - `cmatrix nyancat asciiquarium`
   - `btop ranger onefetch asciinema`
   - `nmap sqlmap mtr bandwhich`
   - `fortune-mod cowsay lolcat figlet toilet`
   - `dust duf jq yq ripgrep fd fzf zoxide`
   - `ponysay` (if available)

2. Creates scripts in `~/.local/bin`:
   - `fye`
   - `hackmenu`
   - `kawaii`
   - `pipes`

3. Patches `~/.zshrc` with aliases and style config.

---

## Safety / Legal

This project includes dual-use tools (nmap/sqlmap). You are responsible for legal use.
Only test systems you own or have explicit authorization to test.

---

## Uninstall

```bash
rm -f ~/.local/bin/fye ~/.local/bin/hackmenu ~/.local/bin/kawaii ~/.local/bin/pipes
# optional: remove aliases manually from ~/.zshrc
```

---

## Roadmap

- v4 neon TUI
- saved target profiles
- optional startup animation toggle
- optional minimal mode
