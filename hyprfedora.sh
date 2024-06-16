COPR=(
    solopasha/hyprland
    erikreinder/SwayNotificationCenter
    tofik/nwg-shell
)

HYPR=(
    adobe-source-code-pro-fonts
    btop
    file-roller
    fira-code-fonts
    fontawesome-fonts-all
    git
    grim
    google-droid-sans-fonts
    google-noto-sans-cjk-fonts
    google-noto-color-emoji-fonts
    google-noto-emoji-fonts
    hypridle
    hyprland
    hyprlock
    hyprpaper
    kitty
    network-manager-applet
    NetworkManager-wifi
    pamixer
    pipewire-alsa
    pipewire-utils
    playerctl
    polkit-gnome
    python3-pip
    qt5ct
    qt6-qt5compat
    qt6-qtsvg
    qt6ct
    rifi-wayland
    sddm
    slurp
    swww
    swappy
    thunar
    thunar-archive-plugin
    thunar-volman
    wlogout
    wl-clipboard
    waybar
    xdg-user-dirs
    xdg-utils
    wpa-supplicant
)

add_config() {
    local file="$1"
    local config="$2"
    grep -qF "$config" "$file" || echo "$config" | sudo tee -a "$file" >/dev/null
}

install_package() {
    sudo dnf5 install -y "$1" 2>&1
}

add_config "/etc/dnf/dnf.conf" "max_parallel_downloads=15"

for repo in "${COPR[@]}"; do
    sudo dnf copr enable -y "$repo" 2>&1 || {printf "%s - Failed to enable copr repo"
    exit 1}
done

sudo dnf update -y
sudo dnf install dnf5 -y

for pkg in "${HYPR[@]}"; do
    install_package "$pkg" 2>&1
done

sudo systemctl set-default graphical.target 2>&1
sudo systemctl enable sddm.service 2>&1
