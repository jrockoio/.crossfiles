#!/bin/zsh

path+=("$HOME/.config/bin")
path+=("$HOME/.config/crossbin")
path+=("$HOME/.cargo/bin")
path+=("$HOME/go/bin") 
path+=("/usr/local/go/bin")

# tmux
bindkey -s ^f "tmux-sessionizer\n"

export LSCOLORS="Cxdxgxfxexegedabagacad"

if hash zoxide 2> /dev/null; then eval "$(zoxide init zsh)"; fi
if hash starship 2> /dev/null; then eval "$(starship init zsh)"; fi
if hash bat 2> /dev/null; then alias cat=bat; fi
if hash exa 2> /dev/null; then
  alias ls=exa
  alias ll='exa -abhgHlS'
  alias lls='exa -abhgHlS -sold'
fi
if hash richgo 2> /dev/null; then alias go=richgo; fi # go test highlighting: github.com/kyoh86/richgo
if hash nvim 2> /dev/null; then alias vim=nvim; fi
alias j='just'

# list sizes of folders in order including hidden
alias dus='du -hs .[^.]* * | sort -hr'

# git 
alias branch='git branch --sort=-committerdate'
alias br="git for-each-ref --sort=-committerdate refs/heads/ --count=30 --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias gco='git checkout'
alias gci='git commit'
alias gst='git status'
alias gpo='git push origin'
alias gdi='git diff'
gad() {
	git add "$1"
	gst
}
alias gps='git push'
alias gpl='git pull'
alias gf='git fetch'
alias gft='git fetch --tags --all --force'
alias grc='git rebase --continue'
alias grm='git rebase master'
alias gpop='git stash pop'
alias gmom='git fetch && git merge origin/master'
alias gsq='git rebase -i HEAD~'
alias gcu='git fetch && git merge --no-edit origin/main'
alias gnow='git commit --amend --date="now" --no-edit'

# fzf
export FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# rust
alias cupd='cargo install-update -gla'
alias cupg='cargo install-update -ga'
. "$HOME/.cargo/env"


# vim
alias v='vim'
export VISUAL=vim
export EDITOR="$VISUAL"
# vi mode
bindkey -v

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# zsh completions
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath+=~/.config/zsh_completions

autoload -Uz compinit
compinit -u
