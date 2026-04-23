HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS
setopt NO_CLOBBER

autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m-1) ]]; then
  compinit -C
else
  compinit
fi

bindkey -e
bindkey '^ ' autosuggest-accept
bindkey '^j' autosuggest-execute
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

PROMPT='[%n@%F{red}%m%f %F{yellow}%3~%f]%(?..%F{red}[%?]%f)%(!.#.$) '

eval "$(zoxide init zsh)"

source $HOME/miniforge3/etc/profile.d/conda.sh

  # Use history and completion for suggestions
  ZSH_AUTOSUGGEST_STRATEGY=(completion)

function kittyrc() {
    nvim ~/.config/kitty/kitty.conf
}
function base() {
    conda activate base
}
function skynet() {
    conda activate skynet
}
function zshrc() {
    nvim ~/.zshrc 
}
function envconfig() {
    nvim ~/.zshenv
}
function reload() {
    exec zsh
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
alias texclean='rm -fv *.aux *.log *.out *.toc *.bbl *.blg *.fdb_latexmk *.fls *.synctex.gz'
alias inkfig='inkscape-figures'
alias :qconda='conda deactivate && echo "[Conda Environment Exited]"'

alias bashrc='${EDITOR:-nvim} $HOME/.bashrc'
alias vimrc='${EDITOR:-nvim} $HOME/.vimrc'
alias nvimrc='${EDITOR:-nvim} $HOME/.config/nvim/init.lua'
alias tmuxconf='${EDITOR:-nvim} $HOME/.tmux.conf'
alias i3rc='${EDITOR:-nvim} $HOME/.config/i3/config'

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#727169"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
