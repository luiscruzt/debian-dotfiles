# ==============================================================================
# BEHAVIOR & HISTORY
# ==============================================================================
HISTFILE="$HOME/.bash_history"
HISTSIZE=50000
HISTFILESIZE=50000

shopt -s histappend               # Append to history file instead of overwriting
HISTCONTROL=ignoreboth:erasedups  # Ignore spaces/duplicates, erase older duplicates
set -o noclobber                  # Prevent accidental overwriting of files with '>'

PROMPT_COMMAND="history -a; history -c; history -r${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# Bash function sourcing
USER_FUNCS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/bash/functions"
if [[ -d "$USER_FUNCS_DIR" ]]; then
    for func_file in "$USER_FUNCS_DIR"/*; do
        [ -f "$func_file" ] && source "$func_file"
    done
fi

# ==============================================================================
# COMPLETION SYSTEM (GNU READLINE)
# ==============================================================================
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

bind 'set colored-stats on'
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'set mark-symlinked-directories on'

# ==============================================================================
# READLINE EDITOR & PROMPT
# ==============================================================================
set -o emacs

PROMPT_DIRTRIM=3

C_RED='\[\e[31m\]'
C_YELLOW='\[\e[33m\]'
C_RESET='\[\e[0m\]'

PS1="[\u@${C_RED}\h${C_RESET} ${C_YELLOW}\w${C_RESET}]\$ "

# ==============================================================================
# TOOL INITIALIZATION
# ==============================================================================

# FZF
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info \
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008' \
--bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"

if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)" 2>/dev/null || source <(fzf --bash)
fi

# Zoxide
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi

# Conda (Lazy Load)
conda() {
    unset -f conda
    source "$HOME/miniforge3/etc/profile.d/conda.sh"
    conda "$@"
}

# ==============================================================================
# FUNCTIONS
# ==============================================================================
zy() {
    local tmp cwd target
    
    if (( $# > 0 )); then
        target="$(zoxide query "$@")" || return 1
        set -- "$target"
    fi

    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    command yazi "$@" --cwd-file="$tmp"
    
    cwd="$(cat -- "$tmp")"
    rm -f -- "$tmp"

    if [[ -n "$cwd" && "$cwd" != "$PWD" && -d "$cwd" ]]; then
        builtin cd -- "$cwd"
    fi
}

zls() {
    local target
    target="$(zoxide query "$@")" || return 1
    ls -hotr --color=auto "$target"
}

qalc() {
    if [ $# -eq 0 ]; then
        command qalc
    else
        command qalc -t "$@"
    fi
}

# ==============================================================================
# ALIAS DEFINITIONS
# ==============================================================================

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias mkdir='mkdir -pv'
alias bat="batcat"
alias clip='xclip -selection clipboard'
alias ls="ls -hotr --color=auto"
alias la="eza -lh --icons --time-style='+%b %d %H:%M' --all --group-directories-first --git"
alias lt="eza --tree --level=2 --icons --group-directories-first"

alias icat="kitten icat"
alias ports='ss -tulanp'

alias texwatch='latexmk -pvc -pdf -interaction=nonstopmode'
alias texclean='latexmk -c'
alias texpurge='latexmk -C'

alias :qconda='conda deactivate && echo "[Conda Environment Exited]"'
alias skynet='conda activate skynet'
alias base='conda activate base'

alias reload='source $HOME/.bashrc'
alias bashrc='nvim $HOME/.bashrc'
alias zshrc='nvim $HOME/.zshrc'
alias vimrc='nvim $HOME/.vimrc'
alias nvimrc='nvim $HOME/.config/nvim/init.lua'
alias kittyrc='nvim ~/.config/kitty/kitty.conf'
alias tmuxconf='nvim $HOME/.tmux.conf'
alias i3rc='nvim $HOME/.config/i3/config'
alias picomrc='nvim $HOME/.config/picom/picom.conf'
