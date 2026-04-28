HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS
setopt NO_CLOBBER
setopt PROMPT_SUBST

autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m-1) ]]; then
  compinit -C
else
  compinit
fi

KEYTIMEOUT=1
bindkey -v


bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history
bindkey -M viins '^R' history-incremental-search-backward

bindkey '^ ' autosuggest-accept
bindkey '^j' autosuggest-execute

function zle-line-init zle-keymap-select {
    if [[ "${KEYMAP}" == "vicmd" ]]; then
        VI_STATE="%F{blue}❮%f"
    else
        VI_STATE="%F{green}%(!.#.$)%f"
    fi
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

PROMPT='[%n@%F{red}%m%f %F{yellow}%3~%f]%(?..%F{red}[%?]%f)${VI_STATE} '

eval "$(zoxide init zsh)"

source $HOME/miniforge3/etc/profile.d/conda.sh

ZSH_AUTOSUGGEST_STRATEGY=(completion)

kittyrc() {
    nvim ~/.config/kitty/kitty.conf
}
base() {
    conda activate base
}
skynet() {
    conda activate skynet
}
zshrc() {
    nvim ~/.zshrc 
}
envconfig() {
    nvim ~/.zshenv
}
reload() {
    exec zsh
}

zls() {
    zoxide query "$@"
    ls -ltr --color=auto "$(zoxide query "$@")"
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

function bless() {
    if [[ -f "$1" ]]; then
        chmod +x "$1"
        mv "$1" "$HOME/.local/bin/"
        print -P "%F{green}Blessed:%f $1 moved to ~/.local/bin/"
    else
        print -P "%F{red}Error:%f File not found."
    fi
}

alias ls="ls -long -t -r --color=auto"
alias la="eza -lh --icons --time-style='+%b %d %H:%M' --sort=modified --reverse --all"
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

alias bashrc='${EDITOR:-nvim} $HOME/.bashrc'
alias vimrc='${EDITOR:-nvim} $HOME/.vimrc'
alias nvimrc='${EDITOR:-nvim} $HOME/.config/nvim/init.lua'
alias tmuxconf='${EDITOR:-nvim} $HOME/.tmux.conf'
alias i3rc='${EDITOR:-nvim} $HOME/.config/i3/config'

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan,underline'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue,bold'
ZSH_AUTOSUGGEST_STRATEGY=(completion)
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
