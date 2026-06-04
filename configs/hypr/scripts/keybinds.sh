#!/usr/bin/env bash
# Show keybindings reference in a wofi dmenu

wofi --show dmenu \
     --prompt "Keybinds" \
     --width 640 \
     --height 520 \
     --no-actions \
     --insensitive << 'EOF'
── Core ───────────────────────────────────────
SUPER + Return         Terminal (alacritty)
SUPER + Q              Close window
SUPER + F              Fullscreen
SUPER + V              Toggle float
SUPER + J              Toggle split (dwindle)
SUPER + E              File manager (thunar)
SUPER + B              Browser (firefox)
SUPER + Space          Launcher (wofi)
SUPER + H              This keybinds menu

── Session ────────────────────────────────────
SUPER + L              Lock screen (hyprlock)
SUPER + SHIFT + M      Logout menu (wlogout)
SUPER + SHIFT + E      Exit Hyprland
SUPER + SHIFT + C      Toggle caffeine (inhibit sleep)
SUPER + SHIFT + B      Show/hide waybar

── Screenshots ────────────────────────────────
Print                  Select area → clipboard
SUPER + Print          Full screen → save file
SUPER + SHIFT + Print  Monitor → clipboard

── Focus ──────────────────────────────────────
SUPER + ← ↑ ↓ →       Move focus

── Move windows ───────────────────────────────
SUPER + SHIFT + ← ↑ ↓ →   Move window

── Resize ─────────────────────────────────────
SUPER + CTRL + ← ↑ ↓ →    Resize window

── Workspaces ─────────────────────────────────
SUPER + 1-0            Switch to workspace 1-10
SUPER + SHIFT + 1-0    Move window to workspace
SUPER + Scroll         Cycle workspaces
3-finger swipe L/R     Cycle workspaces

── Mouse ──────────────────────────────────────
SUPER + LMB            Move window
SUPER + RMB            Resize window

── Audio ──────────────────────────────────────
XF86AudioRaiseVolume   Volume up
XF86AudioLowerVolume   Volume down
XF86AudioMute          Mute toggle
XF86AudioMicMute       Mic mute toggle

── Brightness ─────────────────────────────────
XF86MonBrightnessUp    Brightness up
XF86MonBrightnessDown  Brightness down
EOF
