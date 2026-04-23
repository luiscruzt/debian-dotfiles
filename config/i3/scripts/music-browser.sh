#!/usr/bin/env bash
# music-browser.sh
# Browse and play music from your music library using dmenu.
# Keybinding: $mod+Shift+t
# Dependencies: dmenu, mpv, kitty, shuffle-and-play.py (must be in PATH)

MUSIC_DIR="/media/luiscruz/Toshiba/Hi-Fi Music"

# ── 1. Pick an artist  ─────────────────────────────────────────────────
ARTIST=$(ls "$MUSIC_DIR" | dmenu -i -l 20 -p "Artist:")
[ -z "$ARTIST" ] && exit 0

ARTIST_DIR="$MUSIC_DIR/$ARTIST"

# ── 2. Pick playback mode   ────────────────────────────────────────────
PLAY_MODE=$(printf "Album\nFull Discography\nShuffle\nSingle Song" | dmenu -i -p "$ARTIST:")
[ -z "$PLAY_MODE" ] && exit 0

case "$PLAY_MODE" in

    # Pick an album and play in track order
    Album)
        ALBUM=$(ls "$ARTIST_DIR" | dmenu -i -l 20 -p "Album:")
        [ -z "$ALBUM" ] && exit 0
        kitty -- bash -c "
            find '$ARTIST_DIR/$ALBUM' -type f \( \
                -iname '*.flac' -o -iname '*.mp3' -o \
                -iname '*.m4a' -o -iname '*.opus' -o \
                -iname '*.ogg'  -o -iname '*.wav' \
            \) | sort | mpv --playlist=-
        "
        ;;

    # Play entire discography in album/track order
    "Full Discography")
        kitty -- bash -c "
            find '$ARTIST_DIR' -type f \( \
                -iname '*.flac' -o -iname '*.mp3' -o \
                -iname '*.m4a' -o -iname '*.opus' -o \
                -iname '*.ogg'  -o -iname '*.wav' \
            \) | sort | mpv --playlist=-
        "
        ;;

    # Shuffle entire artist directory
    Shuffle)
        kitty -- bash -c "shuffle-and-play.py '$ARTIST_DIR'"
        ;;

    # Pick a single song from the artist using dmenu
    # Display format: [Album]  Song Title
    "Single Song")
        # Build formatted list: "Album/song.flac" → "[Album]  song.flac"
        SONG=$(find "$ARTIST_DIR" -type f \( \
            -iname '*.flac' -o -iname '*.mp3' -o \
            -iname '*.m4a' -o -iname '*.opus' -o \
            -iname '*.ogg'  -o -iname '*.wav' \
        \) | sort \
           | sed "s|$ARTIST_DIR/||" \
           | sed 's|\([^/]*\)/\(.*\)|[\1]  \2|' \
           | dmenu -i -l 20 -p "Song:")
        [ -z "$SONG" ] && exit 0

        # Reconstruct original relative path from "[Album]  song.flac"
        ALBUM_PART=$(echo "$SONG" | sed 's/^\[\(.*\)\]  .*/\1/')
        FILE_PART=$(echo "$SONG"  | sed 's/^\[.*\]  //')
        kitty -- bash -c "mpv '$ARTIST_DIR/$ALBUM_PART/$FILE_PART'"
        ;;
esac
