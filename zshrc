# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded. pygmalion
ZSH_THEME="spaceship"

SPACESHIP_CHAR_SYMBOL='🦄 '
SPACESHIP_BATTERY_SHOW='false'

SPACESHIP_TIME_SHOW=true
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git teamocil zsh-completions osx httpie vi-mode)

# User configuration
  TERM=xterm-256color

  export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
  export PATH="/usr/local/mysql/bin:$PATH"
  export PATH="$HOME/.composer/vendor/bin:$PATH"
  export PATH=$PATH:$ANDROID_HOME/tools
  export PATH=$PATH:$ANDROID_HOME/platform-tools
  export PATH="/Users/jamesbest/code/flutter/bin:$PATH"
  export PATH="$HOME/.fastlane/bin:$PATH"
  export BAT_THEME="TwoDark"
  export PATH=$PATH:/opt/apache-maven/bin

  export ANDROID_HOME=$HOME/Library/Android/sdk
  export PATH=$PATH:$ANDROID_HOME/emulator
  export PATH=$PATH:$ANDROID_HOME/tools
  export PATH=$PATH:$ANDROID_HOME/tools/bin
  export PATH=$PATH:$ANDROID_HOME/platform-tools
  source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

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

# Drupal Console initialisation
source "$HOME/.console/console.rc" 2>/dev/null

# Teamocil Autocomplete
alias tee='teamocil'
compctl -g '~/.teamocil/*(:t:r)' teamocil

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
# alias v='cd /Volumes'

# TaskWarrior
##############
td () { task delete "$1"; }           # Delete task
tdone () { task "$1" done; }          # Mark task Done
tag () { task add "$1" pro:General }  # Add task to general list
tf () { task pro:"$1" list }          # List tasks for a certain project

alias tl='task list'
alias tc='task calendar'
alias tlg='task pro:General list'
alias ts='task sync'

# Git
##########
alias gs='git status'
alias gr='git remote -v'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias ga='git add .'
alias gpush='git push'
alias gpull='git pull'
alias gme='git config user.name "jim-at-gravitywell"'
gitnm () { git branch --no-merge "$1"; }           # Lists branches not merged into branch passed as arg
alias workname="git config user.name 'James Best' && git config user.email 'james.best@gravitywell.co.uk'"
alias gitname="git config user.name 'James Best' && git config user.email 'jim@justjibba.net'"

# General
##########
alias myip='ip addr show en0'
alias whereami='npx @rafaelrinaldi/whereami -f json'
alias v='nvim'
alias zshrc='vim ~/.zshrc'
alias l='ls -la'
alias c='clear'
alias svim='source ~/.config/nvim/init.vim'
alias sshkey="cat ~/.ssh/id_rsa.pub | pbcopy && echo 'Copied to clipboard.'"
# alias w='curl -4 wttr.in/bristol'
alias generate='date | md5 | cut -c1-16 | pbcopy'
alias f='fuck'
alias morning='node ~/dotfiles/morning-routine-cli/index.js'
alias tree='tree -L 2 -I "node_module"'
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias ctags="`brew --prefix`/bin/ctags"
alias clp='pgcli -h localhost -p $(navy port postgres 5432) -U postgres'
export EDITOR='/usr/local/bin/nvim'

# Watson
##########
alias w='watson'
alias wp='watson projects'
alias wr='watson restart'

# tmux
name () { printf '\033]2;%s\033\\' "$1";tmux set -g pane-border-format "#{pane_index} #T"; }           # Name pane
alias layout='tmux list-windows -F "#{window_active} #{window_layout}" | grep "^1" | cut -d " " -f 2'

# Python
##########
#alias python='python3'

# Vagrant
alias vu='vagrant up'
alias vh='vagrant halt'
alias vp='vagrant provision'
alias vd='vagrant destroy'

# Ngrok
alias ngrok='~/code/ngrok'

# Raspberry pi
alias vncAlexa='open vnc://pi@192.168.1.147:5901'

alias vl='vagrant global-status'

# Dev Shit
###########
alias bs='browser-sync start --server --files "**/*.*"'
alias cat='bat'

# Codepush
###########
cpDeets () { appcenter codepush deployment list -a "$1"; }           # Shows deploy keys for codepush

# Tooling
# alias localeslint='npm install --save-dev eslint eslint-config-standard eslint-plugin-standard eslint-plugin-promise eslint-plugin-import eslint-plugin-node eslint-plugin-prettier babel-eslint eslint-plugin-react eslint-plugin-jest eslint-config-prettier prettier && wget -O .eslintrc.json https://gist.githubusercontent.com/jim-at-jibba/9a88ea40aa2890dae669926c170f9100/raw/76318d61808a16d3bcd5fc7330b859ed0d630143/eslintrc.json'

alias localeslint='npm install --save-dev eslint prettier eslint-config-airbnb eslint-config-prettier eslint-plugin-import eslint-plugin-jsx-a11y eslint-plugin-prettier eslint-plugin-react && wget -O .eslintrc https://gist.githubusercontent.com/jim-at-jibba/c24c9ae16526e4e3fc028d23cce53a87/raw/f3edb188aa02f9e19195628cec9c72a529235318/.eslintrc'
alias localeslintFile='wget https://gist.github.com/jim-at-jibba/9a88ea40aa2890dae669926c170f9100'

# Gravitywell Specific
alias sshAdelie='ssh -i ~/.ssh/AdelieWebOrdering.pem  ec2-user@52.214.85.193'


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh




source ~/dotfiles/tiny.env

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
