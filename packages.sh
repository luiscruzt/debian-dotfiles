#!/usr/bin/env bash
# packages.sh
# Install all dependencies for this dotfiles setup.
# Sections: apt packages, compiled from source, language-specific tools.
# Usage: ./packages.sh

# ── apt packages ──────────────────────────────────────────────────────────────
APT_PACKAGES=(
    # Window manager and display
    i3 i3blocks feh picom xss-lock redshift dmenu

    # Terminal and shell
    kitty zsh zsh-autosuggestions tmux

    # File management
    yazi

    # Audio
    pipewire pipewire-audio pipewire-pulse wireplumber pavucontrol

    # Fonts
    fonts-dejavu fonts-source-code-pro

    # LaTeX
    texlive-full texlive-extra-utils

    # PDF and images
    nsxiv sioyek zathura

    # Utilities
    fzf xclip xdotool maim flameshot
    tesseract-ocr tesseract-ocr-spa tesseract-ocr-eng
    translate-shell unrar ntfs-3g
    smartmontools dex libnotify-bin

    # Development
    git gcc make pkg-config
)

echo "Installing apt packages..."
sudo apt install -y "${APT_PACKAGES[@]}"

# ── Compiled from source ──────────────────────────────────────────────────────

# i3lock-color (replaces i3lock, required for lock screen)
install_i3lock_color() {
    echo "Installing i3lock-color..."
    sudo apt install -y \
        autoconf libpam0g-dev libcairo2-dev libfontconfig1-dev \
        libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev \
        libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev \
        libxcb-xinerama0-dev libxcb-xrm-dev libgif-dev
    git clone https://github.com/Raymo111/i3lock-color.git /tmp/i3lock-color
    cd /tmp/i3lock-color && ./install-i3lock-color.sh
    cd -
}

# clipmenu (clipboard manager, not in Debian repos)
install_clipmenu() {
    echo "Installing clipmenu..."
    sudo apt install -y xdotool xclip
    git clone https://github.com/cdown/clipmenu.git /tmp/clipmenu
    cd /tmp/clipmenu && sudo make install
    cd -
}

install_i3lock_color
install_clipmenu

echo "All packages installed."
