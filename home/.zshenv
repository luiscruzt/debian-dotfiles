export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export BROWSER="firefox"
export MUSIC="/media/luiscruz/Toshiba/Hi-Fi Music"
export CM_MAX_CLIPS=200 # Clipmenu buffer size

typeset -U path
path=(
  "$HOME/.local/bin"
  "$HOME/.juliaup/bin"
  "$HOME/.cargo/bin"
  "$HOME/.elan/bin/"
  $path
)
