HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt appendhistory
setopt incappendhistory 
setopt HIST_REDUCE_BLANKS
setopt NO_CLOBBER

autoload -Uz compinit
compinit -d ~/.cache/zcompdump

eval "$(zoxide init zsh)"
source ~/miniforge3/etc/profile.d/conda.sh
eval "$(starship init zsh)"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#727169"
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

function kittyconfig() {nvim ~/.config/kitty/kitty.conf}
function skynet() { conda activate skynet }
function profile() { nvim ~/.zshrc }
function envconfig() { nvim ~/.zshenv }
function reload() {
    clear
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
    mv "$1" ~/.local/bin/
    chmod +x ~/.local/bin/"$1"
}

alias ls="ls -long -t -r --color=auto"
alias bat="batcat"
alias la="eza --long --icons --no-user --bytes --time-style='+%b %d %H:%M' --sort=modified --reverse --all"
alias lt="eza --tree --icons --level=2"
