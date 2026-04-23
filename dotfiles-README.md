# dotfiles

Personal configuration files for a minimal Debian/i3 setup.

## Setup

```bash
git clone https://github.com/luiscruzt/dotfiles ~/.dotfiles
cd ~/.dotfiles
./packages.sh   # install dependencies
./install.sh    # create symlinks
```

## Structure

```
~/.dotfiles/
├── config/         # XDG config directories (~/.config/)
│   ├── i3/         # i3 window manager
│   ├── kitty/      # terminal
│   ├── fastfetch/  # fastfetch
│   ├── nvim/       # editor
│   ├── mpv/        # media player
│   ├── yazi/       # file manager
│   ├── picom/      # compositor
│   ├── i3blocks/   # status bar
│   ├── nsxiv/      # image viewer
│   ├── latexmk/    # LaTeX build tool
│   ├── zsh/        # zsh plugins
│   ├── sioyek/     # PDF reader
│   └── tmux/       # terminal multiplexer
├── home/           # standalone dotfiles (~/)
│   ├── zshrc
│   ├── zshenv
│   ├── bashrc
│   ├── xinitrc
│   ├── xmodmaprc
│   └── Xresources
├── local/           # some useful scritps (~/.local/bin/)
├── install.sh      # create symlinks
├── packages.sh     # install dependencies
└── README.md
```

## Scripts

| Script | Description |
|---|---|
| `music-browser.sh` | Browse and play music via dmenu |
| `queue-builder.sh` | Multi-select tracks with fzf |
| `kicad-export.sh` | Crop KiCad PDF and move to project figures/ |
| `lab-drive.sh` | Import oscilloscope captures from USB |
| `web.sh` | Open bookmarks or search via dmenu |
| `translate.sh` | Translate text via dmenu using translate-shell |
| `power.sh` | Power management with confirmation via dmenu |
| `redshift-set.sh` | Set display color temperature via dmenu |
| `ocr-clip.sh` | OCR screen selection and copy to clipboard |
| `change-wallpaper.sh` | Set random wallpaper from directory |

## Key bindings (i3)

| Binding | Action |
|---|---|
| `Alt+Return` | Terminal (kitty) |
| `Alt+Space` | dmenu_run |
| `Alt+Shift+T` | Music browser |
| `Alt+Shift+Y` | Queue builder |
| `Alt+Shift+S` | OCR screen selection |
| `Alt+Shift+K` | KiCad PDF export |
| `Alt+C` | Clipboard history |
| `Alt+N` | Redshift color temperature |
| `Alt+F9` | pavucontrol |

## Compiled from source

- **i3lock-color** — extended i3lock with color support
- **clipmenu** — Clipboard management using dmenu 

## Dependencies not in apt

- `neovim` — install via [official releases](https://github.com/neovim/neovim/releases)
- `yazi` — install via cargo: `cargo install yazi-fm`
