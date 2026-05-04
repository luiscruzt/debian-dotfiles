HISTFILE=~/.zsh_history
HISTSIZE=3000 SAVEHIST=3000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS
setopt NO_CLOBBER
setopt PROMPT_SUBST

USER_FUNCS_DIR="${ZDOTDIR:-$HOME}/.config/zsh/functions"
if [[ -d "$USER_FUNCS_DIR" ]]; then
    fpath=("$USER_FUNCS_DIR" $fpath)
    autoload -Uz "$USER_FUNCS_DIR"/*(N.:t)
fi

autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m-1) ]]; then
  compinit -C
else
  compinit
fi

# >> VIM MODE>>

KEYTIMEOUT=1
bindkey -v

bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history

bindkey '^ ' autosuggest-accept
bindkey '^j' autosuggest-execute

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

# << VIM MODE <<

PROMPT='[%n@%F{red}%m%f %F{yellow}%3~%f]${VIM_STATE} '

source $HOME/miniforge3/etc/profile.d/conda.sh

# >> zoxide+yazi functions >>

eval "$(zoxide init zsh)"

zls() {
    zoxide query "$@"
    ls -hotr --color=auto "$(zoxide query "$@")"
}

zy() {
    local tmp cwd target
    
    if [ -n "$1" ]; then
        target="$(zoxide query "$@")"
        [ -d "$target" ] || return 1
        set -- "$target"
    fi
    
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    command yazi "$@" --cwd-file="$tmp"
    
    cwd="$(cat -- "$tmp")"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
    
    rm -f -- "$tmp"
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# << zoxide+yazi functions <<

alias ls="ls -hotr --color=auto"
alias la="eza -lh --icons --time-style='+%b %d %H:%M' --all"
alias lt="eza --tree --level=2 --icons "
alias bat="batcat"
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias mkdir='mkdir -pv'
alias clip='xclip -selection clipboard'
alias icat="kitten icat"
alias ports='ss -tulanp'

alias texwatch='latexmk -pvc -pdf -interaction=nonstopmode'
alias texclean='latexmk -c && rm -fv *.bbl *.run.xml *.synctex.gz'
alias texpurge='latexmk -C && rm -fv *.bbl *.run.xml *.synctex.gz'

alias :qconda='conda deactivate && echo "[Conda Environment Exited]"'
alias skynet='conda activate skynet'
alias base='conda activate base'

alias bashrc='nvim $HOME/.bashrc'
alias zshrc='nvim $HOME/.zshrc'
alias reload='source $HOME/.zshrc'
alias vimrc='nvim $HOME/.vimrc'
alias nvimrc='nvim $HOME/.config/nvim/init.lua'
alias kittyrc='nvim ~/.config/kitty/kitty.conf'
alias tmuxconf='nvim $HOME/.tmux.conf'
alias i3rc='nvim $HOME/.config/i3/config'
alias picomrc='nvim $HOME/.config/picom/picom.conf'

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]='fg=yellow,underline'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue,bold'
ZSH_AUTOSUGGEST_STRATEGY=(completion)
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source <(fzf --zsh)

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info \
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008' \
--bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"
