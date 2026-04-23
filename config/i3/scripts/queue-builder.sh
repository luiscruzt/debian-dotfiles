#!/usr/bin/env bash
# queue-builder.sh
# Build a custom queue by selecting multiple tracks with fzf.
# Keybinding: $mod+Shift+y
# Dependencies: fzf, mpv, kitty

MUSIC_DIR="/media/luiscruz/Toshiba/Hi-Fi Music"

# Run everything inside kitty so fzf has a proper TTY
kitty -- bash -c '
    MUSIC_DIR="/media/luiscruz/Toshiba/Hi-Fi Music"

    # Temporary playlist file — deleted automatically on next boot
    TMPLIST=$(mktemp /tmp/queue-XXXXXX.m3u)

    # Find all audio files, strip the base path for cleaner display in fzf
    find "$MUSIC_DIR" -type f \( \
        -iname "*.flac" -o -iname "*.mp3" -o \
        -iname "*.m4a" -o -iname "*.opus" -o \
        -iname "*.ogg"  -o -iname "*.wav" \
    \) | sort | sed "s|$MUSIC_DIR/||" \
      | fzf --multi \
            --prompt="Queue (Tab=select, Enter=play): " \
            --preview="echo {}" \
            --preview-window=down:1 \
      | sed "s|^|$MUSIC_DIR/|" > "$TMPLIST"  # Restore full paths for mpv

    # Only launch mpv if at least one track was selected
    [ -s "$TMPLIST" ] && mpv --playlist="$TMPLIST"
'
