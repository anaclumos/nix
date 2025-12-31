<h1 align="center">
  <br>
  <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-colours.svg" alt="NixOS" width="100">
  <br>
  Sunghyun's NixOS
  <br>
</h1>

<p align="center">
  <strong>Declarative system configuration for Framework Laptop 13</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/NixOS-25.11_Xantusia-5277C3?style=for-the-badge&logo=nixos&logoColor=white" alt="NixOS">
  <img src="https://img.shields.io/badge/Flakes-Enabled-44cc11?style=for-the-badge" alt="Flakes">
  <img src="https://img.shields.io/badge/Home_Manager-Integrated-blue?style=for-the-badge" alt="Home Manager">
</p>

<p align="center">
  <a href="#installation">Installation</a> •
  <a href="#features">Features</a> •
  <a href="#keyboard">Keyboard</a> •
  <a href="#architecture">Architecture</a>
</p>

---

## Hardware

| Component | Specification |
|-----------|---------------|
| **Laptop** | [Framework Laptop 13 (AMD Ryzen AI 300 Series)](https://frame.work/products/laptop13-diy-amd-ai300) |
| **CPU** | AMD Ryzen AI 9 HX 370 w/ Radeon 890M |
| **RAM** | 96GB DDR5 5600MHz |
| **Storage** | 4TB WD SN850X NVMe |
| **Display** | 2880×1920 @ 120Hz (3:2) |
| **Kernel** | Linux 6.18 LTS |

## Installation

```sh
curl -fsSL https://raw.githubusercontent.com/anaclumos/nix/main/bootstrap.sh | sh
```

Bootstraps a fresh NixOS installation into a fully configured system. Includes hardware detection, firmware updates, and automatic reboot.

## Features

### Security

- **Full disk encryption** — LUKS on root and swap partitions
- **Kernel hardening** — `kptr_restrict`, `dmesg_restrict`, `kexec_load_disabled`
- **Network hardening** — SYN cookies, reverse path filtering, no ICMP redirects
- **SSH via 1Password** — Keys stored in 1Password, never on disk
- **Fingerprint auth** — sudo and login via fprintd
- **Core dumps disabled** — No sensitive memory written to disk

### Performance

- **Zram** — 48GB compressed swap (zstd, 50% of RAM)
- **VM tuning** — `swappiness=180`, optimized for zram workloads
- **IO schedulers** — `none` for NVMe, `mq-deadline` for SATA
- **Systemd initrd** — Faster boot with parallel service startup
- **tmpfs /tmp** — RAM-backed temp directory (50% allocation)
- **AMD P-State** — Active mode for dynamic CPU scaling

### Desktop

- **[GNOME 49 "Brescia"](https://release.gnome.org/49/)** on Wayland with curated extensions
- **Dynamic wallpaper** — Solar gradient synced to Seoul time via [Timewall](https://github.com/bcyran/timewall)
- **[Pretendard GOV](https://github.com/orioncactus/pretendard)** — Korea's pan-government design system typeface with 20+ font aliases
- **Dash to Dock** — Auto-hiding dock with intellihide
- **Unite** — Clean panel without window decorations
- **Blur My Shell** — Gaussian blur effects

### Networking

- **Tailscale** — Mesh VPN with Taildrop file sharing
- **AdGuard Home** — Local DNS filtering
- **ExpressVPN** — Commercial VPN integration
- **systemd-resolved** — DNSSEC with fallback DNS (1.1.1.1, 8.8.8.8)

## Keyboard

This configuration recreates macOS keyboard behavior on Linux using [keyd](https://github.com/rvaiya/keyd).

### Modifier Remapping

| Physical Key | Behavior |
|--------------|----------|
| Left Alt | Command (Ctrl) — copy, paste, cut, tabs |
| Left/Right Super | Option (Alt) — word navigation, word delete |
| Left/Right Ctrl | Control — browser tab navigation |
| Caps Lock | Hyper (Ctrl+Alt+Shift+Super) |

### macOS Shortcuts

| Shortcut | Action |
|----------|--------|
| Cmd + C/V/X | Copy / Paste / Cut |
| Cmd + [ / ] | Back / Forward |
| Cmd + Left/Right | Home / End |
| Cmd + Up/Down | Page Up / Page Down |
| Option + Left/Right | Word jump |
| Option + Backspace | Delete word |

### Hyper Key Chords

Caps Lock acts as a Hyper key. Tap alone to maximize window (Alt+F10). Hold for app switching:

| Chord | Target |
|-------|--------|
| Hyper + F | Nautilus (Super+1) |
| Hyper + J | Chrome (Super+2) |
| Hyper + H/K/L | App slots 3/4/5 |
| Hyper + Enter | Move window to end + top |

### Kana-Style Input

Inspired by Japanese keyboard input on macOS. Each hand has a dedicated language:

| Key | Action |
|-----|--------|
| Left Ctrl (tap) | Switch to English |
| Right Ctrl (tap) | Switch to Korean |

No toggle key. Powered by fcitx5 with `ActivateKeys=Control+Control_R` and `DeactivateKeys=Control+Control_L`.

## Architecture

```
.
├── flake.nix                 # Flake definition with inputs
├── configuration.nix         # Module composition
├── hardware-configuration.nix
├── packages.nix              # Package sets by category
├── modules/
│   ├── options.nix           # Custom module options
│   ├── boot.nix              # Kernel, Plymouth, LUKS
│   ├── power.nix             # Zram, hibernation, IO schedulers
│   ├── security.nix          # Firewall, kernel hardening
│   ├── core.nix              # keyd, Docker, 1Password
│   ├── networking.nix        # Tailscale, AdGuard, VPN
│   ├── gnome.nix             # Desktop environment
│   ├── input-method.nix      # fcitx5 + Hangul
│   ├── nix-settings.nix      # Caches, GC, nix-ld
│   ├── gaming.nix            # Steam, Gamemode
│   └── media.nix             # PipeWire, GPU drivers
├── home/
│   ├── default.nix           # Home Manager entry
│   ├── shell.nix             # Zsh, Atuin, aliases
│   ├── git.nix               # Git + SSH signing
│   ├── gnome-settings.nix    # dconf settings
│   ├── fcitx.nix             # Input method config
│   ├── services.nix          # Timewall, Thunderbird
│   └── autostart.nix         # 1Password, Trayscale
├── fonts/
│   └── default.nix           # Pretendard, Iosevka, font aliases
└── wallpaper/
    └── solar-gradient.heic   # Dynamic wallpaper
```

## Shell Aliases

| Alias | Description |
|-------|-------------|
| `build` | Format, update flake, rebuild, garbage collect |
| `nixgit` | Commit and push with date message |
| `ngc` | Garbage collect (keep 100 generations) |
| `zz` | Open nix config in VS Code |
| `airdrop` | Send screenshots to iPhone via Taildrop |
| `chat` | Codex with high reasoning |
| `ec` / `ed` | ExpressVPN connect / disconnect |

## Development

```sh
nix develop
```

Provides: `nixfmt` (RFC style), `statix`, `deadnix`, `nil`, `nix-tree`, `nvd`, `nix-diff`

## Custom Packages

This configuration uses personal flakes for packages not in nixpkgs:

- [`anaclumos/kakaotalk.nix`](https://github.com/anaclumos/kakaotalk.nix) — Korean messenger
- [`anaclumos/tableplus.nix`](https://github.com/anaclumos/tableplus.nix) — Database GUI

## License

MIT
