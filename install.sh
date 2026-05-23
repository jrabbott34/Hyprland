#!/usr/bin/env bash
# Hyprland dotfiles installer
# Run as your regular user (NOT root). Will prompt for sudo when needed.

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGS_DIR="$DOTFILES_DIR/configs"

# ─── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC}   $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
die()     { echo -e "${RED}[ERR]${NC}  $*"; exit 1; }

[[ $EUID -eq 0 ]] && die "Do not run as root. Run as your normal user."

# ─── Install yay ──────────────────────────────────────────────────────────────
install_yay() {
    if command -v yay &>/dev/null; then
        success "yay already installed"
        return
    fi
    info "Installing yay AUR helper..."
    sudo pacman -S --needed --noconfirm git base-devel
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    (cd "$tmpdir/yay" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
    success "yay installed"
}

# ─── Package list ─────────────────────────────────────────────────────────────
install_packages() {
    info "Installing packages (this will take a while)..."

    # Core audio — required before most GUI stuff
    yay -S --noconfirm --needed \
        pipewire pipewire-pulse pipewire-alsa wireplumber

    # Printing
    yay -S --noconfirm --needed \
        cups cups-pdf system-config-printer

    # Bluetooth GUI
    yay -S --noconfirm --needed \
        blueman

    # Main package set
    yay -S --noconfirm --needed \
        thunar curl git wget htop btop bat thunar-volman gvfs gvfs-afc gvfs-smb samba \
        xfce4-settings tumbler yt-dlp alacritty mpv gedit gnome-keyring seahorse pavucontrol \
        brightnessctl acpi sysstat iw network-manager-applet grim slurp hyprpicker \
        xdg-desktop-portal-wlr hyprwayland-scanner yazi power-profiles-daemon \
        networkmanager-openvpn ttf-font-awesome powerline-fonts-git ttf-firacode-nerd \
        eza cava xdg-desktop-portal-hyprland hyprutils hyprcursor hyprpaper hypridle hyprlock \
        wofi dunst qt5-wayland qt6ct wlogout timeshift yad jq go polkit-gnome waypaper \
        lxappearance-gtk3 firefox openvpn qemu-guest-agent spice-vdagent virt-viewer \
        libreoffice-fresh nwg-look linux linux-firmware linux-headers intel-ucode bluez \
        bluez-utils zsh woff2 wlr-randr waybar ttf-ms-fonts ttf-nerd-fonts-symbols \
        remmina freerdp fish foot virt-manager qemu-full libvirt edk2-ovmf dnsmasq iptables-nft \
        dosfstools gnome-disk-utility wl-clipboard

    # NOTE: icaclient (Citrix) requires manual AUR install — EULA must be accepted.
    # Run manually: yay -S icaclient
    # NOTE: trezor-suite-bin — uncomment if you use a Trezor hardware wallet.
    # yay -S --noconfirm trezor-suite-bin

    success "Packages installed"
}

# ─── Enable services ──────────────────────────────────────────────────────────
enable_services() {
    info "Enabling system services..."
    sudo systemctl enable --now NetworkManager
    sudo systemctl enable --now bluetooth
    sudo systemctl enable --now cups
    sudo systemctl enable --now libvirtd
    sudo systemctl enable --now power-profiles-daemon
    # Add user to libvirt group for VM access
    sudo usermod -aG libvirt,kvm "$(whoami)"
    success "Services enabled"
}

# ─── Deploy configs ───────────────────────────────────────────────────────────
deploy_configs() {
    info "Deploying configs..."
    mkdir -p \
        "$HOME/.config/hypr/scripts" \
        "$HOME/.config/waybar/scripts" \
        "$HOME/.config/wofi" \
        "$HOME/.config/dunst" \
        "$HOME/Pictures/screenshots" \
        "$HOME/Pictures/wallpapers"

    # Hyprland
    cp "$CONFIGS_DIR/hypr/hyprland.conf"  "$HOME/.config/hypr/hyprland.conf"
    cp "$CONFIGS_DIR/hypr/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"
    cp "$CONFIGS_DIR/hypr/hypridle.conf"  "$HOME/.config/hypr/hypridle.conf"
    cp "$CONFIGS_DIR/hypr/hyprlock.conf"  "$HOME/.config/hypr/hyprlock.conf"
    cp "$CONFIGS_DIR/hypr/scripts/"*      "$HOME/.config/hypr/scripts/"
    chmod +x "$HOME/.config/hypr/scripts/"*

    # Waybar
    cp "$CONFIGS_DIR/waybar/config.jsonc" "$HOME/.config/waybar/config.jsonc"
    cp "$CONFIGS_DIR/waybar/style.css"    "$HOME/.config/waybar/style.css"
    cp "$CONFIGS_DIR/waybar/scripts/"*    "$HOME/.config/waybar/scripts/"
    chmod +x "$HOME/.config/waybar/scripts/"*

    # Wofi
    cp "$CONFIGS_DIR/wofi/config"     "$HOME/.config/wofi/config"
    cp "$CONFIGS_DIR/wofi/style.css"  "$HOME/.config/wofi/style.css"

    # Dunst
    cp "$CONFIGS_DIR/dunst/dunstrc"   "$HOME/.config/dunst/dunstrc"

    success "Configs deployed"
}

# ─── Optional: set fish as default shell ──────────────────────────────────────
set_shell() {
    read -rp "Set fish as your default shell? [y/N] " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        chsh -s "$(which fish)"
        success "Default shell set to fish"
    fi
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
    echo -e "\n${BLUE}╔══════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   Hyprland Dotfiles Installer        ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════╝${NC}\n"

    install_yay
    install_packages
    enable_services
    deploy_configs
    set_shell

    echo -e "\n${GREEN}Done!${NC}"
    echo "  • Log out and select Hyprland from your display manager, or run: Hyprland"
    echo "  • Set a wallpaper with: waypaper"
    echo "  • Edit monitor layout in: ~/.config/hypr/hyprland.conf"
    echo "  • Set your weather location: export WEATHER_LOCATION=YourCity in ~/.config/fish/config.fish"
    echo "  • Reboot recommended for group changes (libvirt/kvm) to take effect"
}

main "$@"
