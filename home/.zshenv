export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export BROWSER="firefox"
typeset -U path
path=(
  "$HOME/.local/bin"
  "$HOME/.juliaup/bin"
  "$HOME/.cargo/env"
  $path
)
export PATH

