export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export BROWSER="firefox"
export MUSIC="/media/luiscruz/Toshiba/Hi-Fi Music"

typeset -U path
path=(
  "$HOME/.local/bin"
  "$HOME/.juliaup/bin"
  "$HOME/.cargo/bin"
  $path
)
export PATH

