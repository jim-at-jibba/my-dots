# export LC_ALL=en_US.UTF-8
# Pat to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded. pygmalion
ZSH_THEME="spaceship"

SPACESHIP_CHAR_SYMBOL='🦄 🐙 '
SPACESHIP_BATTERY_SHOW='false'

SPACESHIP_TIME_SHOW=false
SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_EXEC_TIME_SHOW=false
SPACESHIP_NODE_SHOW=false
SPACESHIP_DOCKER_SHOW=false
DISABLE_AUTO_TITLE="true"

plugins=(git zsh-completions httpie vi-mode zsh-autosuggestions zsh-syntax-highlighting)

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
  export PATH="$HOME/neovim/bin:$PATH"
  export PATH="$HOME/bin:$PATH"

  export ANDROID_HOME=$HOME/Library/Android/sdk
  export PATH=$PATH:$ANDROID_HOME/emulator
  export PATH=$PATH:$ANDROID_HOME/tools
  export PATH=$PATH:$ANDROID_HOME/tools/bin
  export PATH=$PATH:$ANDROID_HOME/platform-tools
  export PATH=$PATH:$ANDROID_HOME/build-tools/29.0.2
  export PATH="/usr/local/opt/postgresql@11/bin:$PATH"
  export PATH="/usr/local/opt/python@3.8/bin:$PATH"
  export LDFLAGS="-L/usr/local/opt/readline/lib -L/usr/local/opt/openssl@1.1/lib -L/usr/local/opt/zlib/lib"
  source $ZSH/oh-my-zsh.sh

  export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
  export PATH=$PATH:$JAVA_HOME/bin

  fpath=(~/dotfiles/zsh "${fpath[@]}")
  autoload -Uz utils bip bup bcp tl kp ks vim tmuxify theme

  typeset -U PATH fpath

# }}}

# Auto Jump initialisation
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# intergrates autojump with fzf
j() {
    if [[ "$#" -ne 0 ]]; then
        cd $(autojump $@)
        return
    fi
    cd "$(autojump -s | sort -k1gr | awk '$1 ~ /[0-9]:/ && $2 ~ /^\// { for (i=2; i<=NF; i++) { print $(i) } }' |  fzf --height 40% --reverse --inline-info)"
}

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Git
##########
alias gs="git status -s \
 | fzf --no-sort --reverse \
 --preview 'git diff --color=always {+2} | diff-so-fancy' \
 --bind=ctrl-j:preview-down --bind=ctrl-k:preview-up \
 --preview-window=right:60%:wrap"
alias gr='git remote -v'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias ga='git add .'
alias gpush='git push'
alias gpull='git pull'
alias gme='git config user.name "jim-at-jibba"'
gitnm () { git branch --no-merge "$1"; }           # Lists branches not merged into branch passed as arg
alias workname="git config user.name 'James Best' && git config user.email 'james.best@gravitywell.co.uk'"
alias gitname="git config user.name 'James Best' && git config user.email 'jim@justjibba.net'"
alias lg="lazygit"

# General
##########
alias myip='ip addr show en0'
alias whereami='npx @rafaelrinaldi/whereami -f json'
alias v='nvim'
alias zshrc='vim ~/.zshrc'
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
alias qotd="curl GET http://quotes.rest/qod.json | jq '. | {quote: .contents.quotes[0].quote, author: .contents.quotes[0].author }'"
alias lip="ip addr show en0"
alias server="python3 -m http.server"
alias python3='python'

# export EDITOR='~/neovim/bin/nvim'

# Docker
alias ld="lazydocker"

# go
alias coverage="go test -coverprofile=coverage.out && go tool cover -html=coverage.out"

# Taskwarrior
alias in="task add +in"

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
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

# Teamocil Autocomplete
# alias tee='teamocil'
compctl -g '~/.teamocil/*(:t:r)' teamocil

# Python
##########
#alias python='python3'

# Hacking
##########
alias papk="~/hacking/scripts/pull-apk.sh"
alias patch="~/hacking/scripts/patch.sh"

# Vagrant
alias vu='vagrant up'
alias vh='vagrant halt'
alias vp='vagrant provision'
alias vd='vagrant destroy'

# Ngrok
alias ngrok='~/code/ngrok'

# Dev Shit
###########
alias bs='npx browser-sync start --server --files "**/*.*"'
alias cat='bat'
alias genyshell='/Applications/Genymotion\ Shell.app/Contents/MacOS/genyshell'
alias nmlist='find . -name "node_modules" -type d -prune -print | xargs du -chs'
alias nmdelete='find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;'
alias readme='npx readme-md-generate'

# twf

twf-widget() {
  local selected=$(twf --height=0.5)
  BUFFER="$BUFFER$selected"
  zle reset-prompt
  zle end-of-line
  return $ret
}
zle -N twf-widget
bindkey '^w' twf-widget

# Codepush
###########
cpDeets () { appcenter codepush deployment list -a "$1"; }           # Shows deploy keys for codepush

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/jamesbest/.config/yarn/global/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/jamesbest/.config/yarn/global/node_modules/tabtab/.completions/slss.zsh

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

#tmuxify

# # The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/james.best/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/james.best/google-cloud-sdk/path.zsh.inc'; fi

# # The next line enables shell command completion for gcloud.
# if [ -f '/Users/james.best/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/james.best/google-cloud-sdk/completion.zsh.inc'; fi
# if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi

# source /Users/james.best/Library/Preferences/org.dystroy.broot/launcher/bash/br

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# Added by serverless binary installer
# export PATH="$HOME/.serverless/bin:$PATH"

# export PATH="$HOME/.poetry/bin:$PATH"

eval $(thefuck --alias)

if command -v pyenv 1>/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi


export PATH="$HOME/.poetry/bin:$PATH"
