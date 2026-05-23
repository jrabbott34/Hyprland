# Hyprland Dotfiles

Minimalist Hyprland build for Arch Linux — Catppuccin Mocha theme throughout.

## What's included

| Component   | App                        |
|-------------|----------------------------|
| Compositor  | Hyprland                   |
| Bar         | Waybar                     |
| Launcher    | Wofi                       |
| Terminal    | Alacritty / Foot           |
| Files       | Thunar                     |
| Notify      | Dunst                      |
| Wallpaper   | Hyprpaper + Waypaper (GUI) |
| Idle/Lock   | Hypridle + Hyprlock        |
| Logout menu | Wlogout                    |
| VMs         | QEMU + virt-manager        |
| Office      | LibreOffice (+ MS Fonts)   |
| AUR helper  | Yay                        |

## Install

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

## Keybinds (SUPER = Windows key)

| Keybind              | Action                        |
|----------------------|-------------------------------|
| SUPER + Enter        | Terminal (alacritty)          |
| SUPER + R            | App launcher (wofi)           |
| SUPER + E            | File manager (thunar)         |
| SUPER + B            | Browser (firefox)             |
| SUPER + Q            | Close window                  |
| SUPER + F            | Fullscreen                    |
| SUPER + V            | Toggle float                  |
| SUPER + L            | Lock screen                   |
| SUPER + SHIFT + M    | Logout menu (wlogout)         |
| SUPER + SHIFT + C    | Toggle caffeine (no sleep)    |
| SUPER + 1-0          | Switch workspace              |
| SUPER + SHIFT + 1-0  | Move window to workspace      |
| SUPER + H/J/K/L      | Move focus (vim keys)         |
| SUPER + CTRL + arrows| Resize window                 |
| Print                | Screenshot region → clipboard |
| SUPER + Print        | Screenshot full → file        |

## Waybar modules

- **Workspaces** — click to switch
- **Clock** — click to toggle date, tooltip shows calendar
- **Weather** — auto-detects location; set `WEATHER_LOCATION=YourCity` in your shell profile for accuracy
- **Caffeine** — click to toggle sleep inhibit (SUPER+SHIFT+C also works)
- **Bluetooth** — click opens blueman
- **Network** — click opens nm-connection-editor
- **CPU / RAM** — click opens btop in alacritty

## Post-install tweaks

```bash
# Set your weather city
echo 'set -x WEATHER_LOCATION "New York"' >> ~/.config/fish/config.fish

# Set a wallpaper
waypaper

# Edit monitors (resolution, refresh rate, multi-monitor)
$EDITOR ~/.config/hypr/hyprland.conf   # look for the monitor= line

# Theme GTK apps to match
nwg-look
```

## Notes

- `icaclient` (Citrix) must be installed manually — it requires EULA acceptance
- `trezor-suite-bin` is commented out in install.sh — uncomment if needed
- Group changes for libvirt/kvm take effect after reboot
