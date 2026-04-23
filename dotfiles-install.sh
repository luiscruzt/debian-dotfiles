#!/usr/bin/env bash
# install.sh
# Creates symlinks from ~/.dotfiles 
# Run from within the ~/.dotfiles directory
# Usage: ./install.sh

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# ── Helper ────────────────────────────────────────────────────────────────────
link() {
    local src="$1"
    local dst="$2"
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        echo "exists: $dst — skipping"
    else
        ln -s "$src" "$dst"
        echo "linked: $dst"
    fi
}

# ── Config directories ────────────────────────────────────────────────────────
mkdir -p "$HOME/.config"

link "$DOTFILES/config/i3"        "$HOME/.config/i3"
link "$DOTFILES/config/i3blocks"  "$HOME/.config/i3blocks"
link "$DOTFILES/config/picom"     "$HOME/.config/picom"
link "$DOTFILES/config/fastfetch" "$HOME/.config/fastfetch"
link "$DOTFILES/config/zsh"       "$HOME/.config/zsh"
link "$DOTFILES/config/kitty"     "$HOME/.config/kitty"
link "$DOTFILES/config/nvim"      "$HOME/.config/nvim"
link "$DOTFILES/config/yazi"      "$HOME/.config/yazi"
link "$DOTFILES/config/tmux"      "$HOME/.config/tmux"
link "$DOTFILES/config/mpv"       "$HOME/.config/mpv"
link "$DOTFILES/config/nsxiv"     "$HOME/.config/nsxiv"
link "$DOTFILES/config/latexmk"   "$HOME/.config/latexmk"
link "$DOTFILES/config/sioyek"    "$HOME/.config/sioyek"

# ── Scripts ───────────────────────────────────────────────────────────────────
link "$DOTFILES/local/bin " "$HOME/.local/bin"

# ── Standalone files ──────────────────────────────────────────────────────────
link "$DOTFILES/home/.zshrc"      "$HOME/.zshrc"
link "$DOTFILES/home/.zshenv"     "$HOME/.zshenv"
link "$DOTFILES/home/.bashrc"     "$HOME/.bashrc"
link "$DOTFILES/home/.xinitrc"    "$HOME/.xinitrc"
link "$DOTFILES/home/.xmodmaprc"  "$HOME/.xmodmaprc"
link "$DOTFILES/home/.Xresources" "$HOME/.Xresources"

echo "Done."
