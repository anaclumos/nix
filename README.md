# Sunghyun's NixOS


![Framework](https://img.shields.io/badge/Framework-Laptop_13-000000?style=flat&logo=framework&logoColor=white)
![Display](https://img.shields.io/badge/Display-2880x1920_@_120Hz-000000?style=flat)
![RAM](https://img.shields.io/badge/RAM-Crucial_96GB_DDR5_5600MHz-000000?style=flat)
![Storage](https://img.shields.io/badge/Storage-4TB_SN850X-000000?style=flat)

![AMD](https://img.shields.io/badge/Ryzen_AI_9_HX_370-ED1C24?style=flat&logo=amd&logoColor=white)
![Radeon](https://img.shields.io/badge/Radeon-890M-ED1C24?style=flat&logo=amd&logoColor=white)

![NixOS](https://img.shields.io/badge/NixOS-25.11-5277C3?style=flat&logo=nixos&logoColor=white)
![GNOME](https://img.shields.io/badge/GNOME-49.2-4A86CF?style=flat&logo=gnome&logoColor=white)
![Wayland](https://img.shields.io/badge/Wayland-Mutter-FFBC00?style=flat&logo=wayland&logoColor=white)
![Kernel](https://img.shields.io/badge/Kernel-6.18.0-FCC624?style=flat&logo=linux&logoColor=black)


## Quick Install

```sh
nix-shell -p curl --run 'curl -fsSL https://raw.githubusercontent.com/anaclumos/nix/main/bootstrap.sh | sh'
```

## Hyper Key

Caps Lock becomes a **Hyper key** (Ctrl+Alt+Shift+Super). Tapping it alone triggers `Alt+F10` (maximize window). Holding it enables app-switching chords:

| Chord | Action |
|-------|--------|
| Hyper + J | Focus Chrome (Super+2) |
| Hyper + K | Focus app slot 4 |
| Hyper + L | Focus app slot 5 |
| Hyper + H | Focus app slot 3 |
| Hyper + F | Focus Nautilus (Super+1) |
| Hyper + Enter | Move window to end + top |

## Kana-Style Language Switching

Inspired by Japanese Kana input on macOS:

- **Left Control (tap)** → Switch to English
- **Right Control (tap)** → Switch to Korean (Hangul)

No toggle key. Each hand has a dedicated language. Powered by fcitx5 with `ActivateKeys=Control+Control_R` and `DeactivateKeys=Control+Control_L`.

## Mac-Like Shortcuts

Keyd remaps physical keys to feel like macOS:

| Physical Key | Behavior |
|--------------|----------|
| Left Alt | Command (Ctrl) — copy, paste, cut, tab switching |
| Left/Right Super | Option (Alt) — word navigation, word delete |
| Left/Right Control | Control — browser tab navigation |
| Command + [ / ] | Back / Forward (Alt+Left/Right) |
| Command + Left/Right | Home / End |
| Command + Up/Down | Page Up / Page Down |
| Option + Left/Right | Word jump (Ctrl+Left/Right) |
| Option + Backspace | Delete word (Ctrl+Backspace) |

## Airdrop

```sh
airdrop  # sends all PNGs in ~/Screenshots to iPhone via Taildrop, then deletes them
```

## Other Shortcuts

| Shortcut | Action |
|----------|--------|
| Ctrl + Space | GNOME Overview (Spotlight-like) |
| Ctrl + Shift + Space | 1Password Quick Access |
| Ctrl + L | Lock screen |
| Ctrl + G | Clipboard history |

## Features

### Performance Optimizations

- **Zram swap** with zstd compression (50% of RAM)
- **IO schedulers** tuned for NVMe (none) and SATA SSDs (mq-deadline)
- **VM tuning** optimized for zram (swappiness=180)
- **tmpfs /tmp** for faster temporary file operations
- **Plymouth** for graphical boot with quiet splash

### Security Hardening

- **Firewall** enabled with Tailscale trusted interface
- **Kernel hardening**: kptr_restrict, dmesg_restrict, kexec disabled
- **Network hardening**: rp_filter, tcp_syncookies, no ICMP redirects
- **Sudo**: wheel-only, fingerprint auth enabled
- **Boot**: editor disabled, core dumps disabled

### Nix Configuration

- **Binary caches**: nixos.org + nix-community cachix
- **Auto garbage collection**: weekly, 30-day retention
- **Auto store optimization**: weekly
- **nix-ld**: pre-configured for common libraries

### Networking

- **systemd-resolved** with DNSSEC and fallback DNS (1.1.1.1, 8.8.8.8)
- **Tailscale** with client routing features
- **AdGuard Home** for local DNS filtering
- **WiFi powersave** enabled

## Development

Enter the development shell with nix tooling:

```sh
nix develop
```

Available tools:
- `nixfmt` - Format nix files (RFC style)
- `statix` - Lint nix files
- `deadnix` - Find dead code
- `nil` - Nix LSP
- `nix-tree` - Explore dependencies
- `nvd` - Compare generations
- `nix-diff` - Diff derivations

## Shell Aliases

| Alias | Description |
|-------|-------------|
| `build` | Format, update flake, rebuild system, garbage collect |
| `nixgit` | Commit and push nix config with date |
| `ngc` | Garbage collect (keep 100 generations) |
| `ec` / `ed` | ExpressVPN connect / disconnect |
| `zz` | Open nix config in VS Code |
| `chat` | Codex with high reasoning |
| `airdrop` | Send screenshots to iPhone via Taildrop |
