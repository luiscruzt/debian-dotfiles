. "$HOME/.cargo/env"

export STARSHIP_CONFIG=~/.config/starship/starship.toml
export EDITOR=nvim
export VISUAL=nvim

typeset -U path
path=(
  $HOME/.local/bin
  /opt/nvim-linux64/bin
  $HOME/.juliaup/bin
  $path
)
export PATH

