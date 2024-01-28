# https://dev.to/thraizz/fix-slow-zsh-startup-due-to-nvm-408k
# zmodload zsh/zprof
# export LC_ALL=en_US.UTF-8
# Pat to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded. pygmalion
# ZSH_THEME="spaceship"

SPACESHIP_CHAR_SYMBOL='🦄 🐙 '
SPACESHIP_BATTERY_SHOW='false'

SPACESHIP_TIME_SHOW=false
SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_EXEC_TIME_SHOW=false
SPACESHIP_NODE_SHOW=false
SPACESHIP_DOCKER_SHOW=false
DISABLE_AUTO_TITLE="true"

# plugins=(git zsh-completions httpie vi-mode zsh-autosuggestions zsh-syntax-highlighting)
# plugins=(git zsh-completions httpie vi-mode zsh-autosuggestions)
zstyle ':omz:plugins:nvm' lazy yes
plugins=(git vi-mode nvm zsh-autosuggestions)

# User configuration
# TERM=xterm-256color
# TERM=screen-256color

# Exports and (auto)loading {{{
  export GOPATH=$HOME/go
  export GOBIN=$GOPATH/bin
  export FZF_DEFAULT_OPTS="--height=50% --min-height=15 --reverse"
  # export FZF_DEFAULT_COMMAND='fd --type file --color=always'
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export BAT_THEME="TwoDark"

  export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
  export PATH="/usr/local/mysql/bin:$PATH"
  export PATH="/usr/local/go/bin:$PATH"
  export PATH=$PATH:$GOBIN
  export PATH="$HOME/.composer/vendor/bin:$PATH"
  export PATH="$HOME/Library/Python/3.7/bin:$PATH"
  export PATH="$HOME/dotfiles/alacritty:$PATH"
  export PATH=$PATH:$ANDROID_HOME/tools
  export PATH=$PATH:$ANDROID_HOME/platform-tools
  export PATH="/Users/jamesbest/code/flutter/bin:$PATH"
  export PATH="$HOME/.fastlane/bin:$PATH"
  export PATH=$PATH:/opt/apache-maven/bin
  export PATH="/usr/local/opt/helm@2/bin:$PATH"
  export PATH=/opt/homebrew/bin:$PATH
  export PATH=/opt/homebrew/sbin:$PATH
  export PATH="$HOME/neovim/bin:$PATH"
  export PATH="$HOME/.rover/bin:$PATH"
  export PATH="$HOME/bin:$PATH"
  export PATH="$HOME/.local/bin:$PATH"

  export ANDROID_HOME=$HOME/Library/Android/sdk
  export PATH=$PATH:$ANDROID_HOME/emulator
  export PATH=$PATH:$ANDROID_HOME/tools
  export PATH=$PATH:$ANDROID_HOME/tools/bin
  export PATH=$PATH:$ANDROID_HOME/platform-tools
  export PATH=$PATH:$ANDROID_HOME/build-tools/29.0.2
  export PATH="/usr/local/opt/postgresql@11/bin:$PATH"
  export PATH="/usr/local/opt/python@3.8/bin:$PATH"
  export PATH="$HOME/.rbenv/shims:$PATH"
  export PATH="$HOME/.rbenv/bin:$PATH"
  export PATH="/Users/jamesbest/.cargo/bin:$PATH"
  export PATH="$HOME/bin:$PATH"
  export LDFLAGS="-L/usr/local/opt/readline/lib -L/usr/local/opt/openssl@3.2/lib -L/usr/local/opt/zlib/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/openssl@3.2/include -I/usr/local/opt/zlib/include"
  source $ZSH/oh-my-zsh.sh


  # make iex keep shell history
  export ERL_AFLAGS="-kernel shell_history enabled"

  # export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
  export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
  export JAVA_11_HOME=$(/usr/libexec/java_home -v11)
  export PATH=$PATH:$JAVA_11_HOME/bin

  alias java8='export JAVA_HOME=$JAVA_8_HOME'
  alias java11='export JAVA_HOME=$JAVA_11_HOME'

  # default to Java 11
  java11

  fpath=(~/dotfiles/zsh "${fpath[@]}")
  autoload -Uz utils tl kp ks vim tmuxify theme tea

  typeset -U PATH fpath

# }}}

# Auto Jump initialisation
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# # intergrates autojump with fzf
j() {
    if [[ "$#" -ne 0 ]]; then
        cd $(autojump $@)
        return
    fi
    cd "$(autojump -s | sort -k1gr | awk '$1 ~ /[0-9]:/ && $2 ~ /^\// { for (i=2; i<=NF; i++) { print $(i) } }' |  gum filter --placeholder 'Search....')"
}

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# BT
alias bton="blueutil -p 1"
alias btoff="blueutil -p 0"

# Git
##########
alias gs="git status -s \
 | fzf --no-sort --reverse \
 --preview 'git diff --color=always {+2} | diff-so-fancy' \
 --bind=ctrl-j:preview-down --bind=ctrl-k:preview-up \
 --preview-window=right:60%:wrap"
alias gr='git remote -v'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glogNoDays="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit"
alias ga='git add .'
alias gpush='git push'
alias gpull='git pull'
alias gme='git config user.name "jim-at-jibba"'
gitnm () { git branch --no-merge "$1"; }           # Lists branches not merged into branch passed as arg
alias workname="git config user.name 'James Best' && git config user.email 'james.best@reedr.co'"
alias gitname="git config user.name 'James Best' && git config user.email 'jim@justjibba.net'"
alias lg="lazygit"
alias epoc="date +%s | pbcopy"
alias cput='sudo powermetrics --samplers smc |grep -i "CPU die temperature"'

# General
##########
alias whereami='npx @rafaelrinaldi/whereami -f json'
alias v='NVIM_APPNAME=nvim-minimal nvim'
alias zshrc='vim ~/.zshrc'
alias reload='source ~/.zshrc'
alias l='exa --long --header --all --icons'
alias ls='exa --header'
alias tree='exa --tree --level=2'
alias c='clear'
alias svim='source ~/.config/nvim/init.vim'
alias sshkey="cat ~/.ssh/id_rsa.pub | pbcopy && echo 'Copied to clipboard.'"
alias npmLocal="npm list -g --depth 0"
# alias w='curl -4 wttr.in/bristol'
alias generate='date | md5 | cut -c1-16 | pbcopy'
alias f='fuck'
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias clp='pgcli -h localhost -p $(navy port postgres 5432) -U postgres'
# alias cp='pgcli -h localhost -U jamesbest'
alias qotd="curl GET http://quotes.rest/qod.json | jq '. | {quote: .contents.quotes[0].quote, author: .contents.quotes[0].author }'"
alias lip="ip addr show en0"
alias server="python3 -m http.server"
alias daily='teamocil mob; teamocil wiki; teamocil spotify'
export EDITOR='/Users/jamesbest/neovim/bin/nvim'
export REACT_EDITOR='/Users/jamesbest/neovim/bin/nvim'
export sso='aws sso login --profile breedr_develop_data_analysis_user'

# Docker
alias ld="lazydocker"

# go
alias coverage="go test -coverprofile=coverage.out && go tool cover -html=coverage.out"

# tmux
name () { printf '\033]2;%s\033\\' "$1";tmux set -g pane-border-format "#{pane_index} #T"; }           # Name pane
alias layout='tmux list-windows -F "#{window_active} #{window_layout}" | grep "^1" | cut -d " " -f 2'

# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm irc` will attach to the irc session (if it exists), else it will create it.

tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | gum filter --placeholder "Pick a session") &&  tmux $change -t "$session" || echo "No sessions found."
}

# Teamocil Autocomplete
alias tee='teamocil'

# Hacking
##########
alias papk="~/hacking/scripts/pull-apk.sh"
alias patch="~/hacking/scripts/patch.sh"

# Dev Shit
###########
alias bs='npx browser-sync start --server --files "**/*.*"'
alias cat='bat'
alias genyshell='/Applications/Genymotion\ Shell.app/Contents/MacOS/genyshell'
alias nmlist='find . -name "node_modules" -type d -prune -print | xargs du -chs'
alias nmdelete='find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;'
alias readme='npx readme-md-generator'
alias run="(jq -r '.scripts|to_entries[]|((.key))' package.json) | fzf-tmux -p --border-label='Yarn run' | xargs yarn"
alias love='open "$(basename "$PWD")" -a /Applications/love.app'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

eval "$(starship init zsh)"

eval $(thefuck --alias)
export PATH="$HOME/.poetry/bin:$PATH"
# export PATH="$PATH:/Users/jamesbest/.kit/bin"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

### Add these next lines to protect your system python from
### pollution from 3rd-party packages

# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true

# commands to override pip restriction above.
# use `gpip` or `gpip3` to force installation of
# a package in the global python environment
# Never do this! It is just an escape hatch.
gpip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}
gpip3(){
   PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}


eval "$(atuin init zsh)"

# source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# bun completions
[ -s "/Users/jamesbest/.bun/_bun" ] && source "/Users/jamesbest/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# flashlight
export PATH="/Users/jamesbest/.flashlight/bin:$PATH"
# zprof
