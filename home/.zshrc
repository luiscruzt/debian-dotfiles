# ==============================================================================
# BEHAVIOR & HISTORY
# ==============================================================================
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=3000 
SAVEHIST=3000

setopt APPEND_HISTORY          # Append to history file instead of overwriting
setopt SHARE_HISTORY           # Share history across concurrent sessions
setopt HIST_IGNORE_DUPS        # Do not record an event that was just recorded again
setopt HIST_IGNORE_ALL_DUPS    # Delete old recorded event if new event is a duplicate
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks before recording
setopt NO_CLOBBER              # Prevent accidental overwriting of files with '>'
setopt PROMPT_SUBST            # Allow variable substitution in prompt


USER_FUNCS_DIR="${ZDOTDIR:-$HOME}/.config/zsh/functions"
if [[ -d "$USER_FUNCS_DIR" ]]; then
    fpath=("$USER_FUNCS_DIR" $fpath)
    autoload -Uz "$USER_FUNCS_DIR"/*(N.:t)
fi

# ==============================================================================
# COMPLETION SYSTEM 
# ==============================================================================
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m-1) ]]; then
    compinit -C
else
    compinit
fi

zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.cache/zsh/zcompcache"

# -- Categorization & Grouping --
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select

# -- Typography --
zstyle ':completion:*:descriptions' format ' %F{blue}> %B%d%b%f'
zstyle ':completion:*:warnings' format ' %F{red}! No matches found%f'
zstyle ':completion:*:messages' format ' %F{green}* %d%f'
zstyle ':completion:*:corrections' format ' %F{magenta}~ %B%d%b (errors: %e)%f'

# -- File Coloring --
if [[ -n "$LS_COLORS" ]]; then
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
fi

# -- Fuzzy matching --
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*:approximate:*' max-errors 'reply=($(( ($#PREFIX + $#SUFFIX) / 3 )))'

# ==============================================================================
# ZSH LINE EDITOR (ZLE) & VIM MODE
# ==============================================================================
KEYTIMEOUT=1
bindkey -v

# History search in Vim insert mode
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history

# Autosuggestion bindings
bindkey '^ ' autosuggest-accept

# Vim Mode State Indicator
function zle-line-init zle-keymap-select {
    if [[ "${KEYMAP}" == "vicmd" ]]; then
        VIM_STATE="%F{blue}@%f"
    else
        VIM_STATE="%F{green}%(!.#.$)%f"
    fi
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# -- PROMPT --
PROMPT='[%n@%F{red}%m%f %F{yellow}%3~%f]${VIM_STATE} '

# ==============================================================================
# TOOL INITIALIZATION
# ==============================================================================

# FZF
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info \
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008' \
--bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"

# evaluate tools only if they are installed
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# -- Conda --

conda() {
    unfunction conda
    source "$HOME/miniforge3/etc/profile.d/conda.sh"
    conda "$@"
}

# ==============================================================================
# FUNCTIONS
# ==============================================================================
# Optimized Yazi wrapper with Zoxide integration
zy() {
    local tmp cwd target
    
    # If arguments are provided, resolve path via zoxide first
    if (( $# > 0 )); then
        target="$(zoxide query "$@")" || return 1
        set -- "$target"
    fi

    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    command yazi "$@" --cwd-file="$tmp"
    
    # Read output and cleanly switch directories if changed
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

# -- File Actions --
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

# -- LaTeX Build System --
alias texwatch='latexmk -pvc -pdf -interaction=nonstopmode'
alias texclean='latexmk -c'  # Requires ~/.latexmkrc configuration
alias texpurge='latexmk -C'  # Requires ~/.latexmkrc configuration

# -- Environments (Conda) --
alias :qconda='conda deactivate && echo "[Conda Environment Exited]"'
alias skynet='conda activate skynet'
alias base='conda activate base'

# -- Configuration (Dotfiles) --
alias reload='source $HOME/.zshrc'
alias bashrc='nvim $HOME/.bashrc'
alias zshrc='nvim $HOME/.zshrc'
alias vimrc='nvim $HOME/.vimrc'
alias nvimrc='nvim $HOME/.config/nvim/init.lua'
alias kittyrc='nvim ~/.config/kitty/kitty.conf'
alias tmuxconf='nvim $HOME/.tmux.conf'
alias i3rc='nvim $HOME/.config/i3/config'
alias picomrc='nvim $HOME/.config/picom/picom.conf'

# ==============================================================================
# PLUGINS
# ==============================================================================
ZSH_AUTOSUGGEST_STRATEGY=(completion)
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ZSH-SYNTAX-HIGHLIGHTING
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]='fg=yellow,underline'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue,bold'
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
