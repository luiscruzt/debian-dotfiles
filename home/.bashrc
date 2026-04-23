# Exit if not running interactively
[[ $- != *i* ]] && return

# --- 2. SHELL OPTIONS ---
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s progcomp
shopt -s cdspell
# --- 3. HISTORY ---
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=10000
HISTFILE="$HOME/.bash_history"

# Truncate path to last 3 levels
export PROMPT_DIRTRIM=3

__bash_status() {
    local EXIT="$?"
    if [[ $EXIT -ne 0 ]]; then
        echo -e "\e[31m[$EXIT]\e[0m"
    fi
}

# [user@host path] [status] $
PS1='[\[\e[31m\]\u\[\e[0m\]@\[\e[32m\]\h\[\e[0m\] \[\e[33m\]\w\[\e[0m\]]$(__bash_status)\$ '
# --- 5. ENVIRONMENT ---
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"

# --- 6. ALIASES ---
alias ls="ls -long -t -r --color=auto"
alias la="eza -lh --icons --time-style='+%b %d %H:%M' --sort=modified --reverse --all"
alias lt="eza --tree --level=2 --icons"
alias bat="batcat"
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias mkdir='mkdir -pv'
alias clip='xclip -selection clipboard'
alias texclean='rm -fv *.aux *.log *.out *.toc *.bbl *.blg *.fdb_latexmk *.fls *.synctex.gz'
alias :qconda='conda deactivate && echo "[Conda Environment Exited]"'
alias base='conda activate base'
alias skynet='conda activate skynet'


alias bashrc='${EDITOR:-nvim} $HOME/.bashrc'
alias vimrc='${EDITOR:-nvim} $HOME/.vimrc'
alias nvimrc='${EDITOR:-nvim} $HOME/.config/nvim/init.lua'
alias tmuxconf='${EDITOR:-nvim} $HOME/.tmux.conf'
alias i3rc='${EDITOR:-nvim} $HOME/.config/i3/config'
alias zshrc='${EDITOR:-nvim} $HOME/.zshrc'
alias kittyrc='${EDITOR:-nvim} $HOME/.config/kitty.conf'
reload()    { exec bash; }

# Yazi with CWD persistence
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

function bless() {
    if [[ -f "$1" ]]; then
        chmod +x "$1"
        mv "$1" "$HOME/.local/bin/"
        print -P "%F{green}Blessed:%f $1 moved to ~/.local/bin/"
    else
        print -P "%F{red}Error:%f File not found."
    fi
}

# Zoxide
eval "$(zoxide init bash)"

# Conda
[[ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]] && . "$HOME/miniforge3/etc/profile.d/conda.sh"

# Julia & Cargo
[[ -d "$HOME/.juliaup/bin" ]] && export PATH="$HOME/.juliaup/bin:$PATH"
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
