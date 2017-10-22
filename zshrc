# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded. pygmalion
ZSH_THEME="spaceship"

SPACESHIP_PROMPT_SYMBOL='🦄 '

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
plugins=(git teamocil zsh-completions)

# User configuration

  export ANDROID_HOME=${HOME}/Library/Android/sdk
  export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
  export PATH="/usr/local/mysql/bin:$PATH"
  export PATH="$HOME/.composer/vendor/bin:$PATH"
  export PATH=$PATH:$ANDROID_HOME/tools
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
alias v='cd /Volumes'

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
alias gme='git config user.name "jim-at-jibba"'

# General
##########
alias zshrc='vim ~/.zshrc'
alias l='ls -la'
alias svim='source ~/.vimrc'
alias sshkey="cat ~/.ssh/id_rsa.pub | pbcopy && echo 'Copied to clipboard.'"
alias w='curl -4 wttr.in/bristol'
alias generate='date | md5 | cut -c1-16 | pbcopy'
alias f='fuck'
alias morning='node ~/dotfiles/morning-routine-cli/index.js'
alias tree='tree -L 2 -I "node_module"'
alias layout='tmux list-windows -F "#{window_active} #{window_layout}" | grep "^1" | cut -d " " -f 2'
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# tmux

name () { printf '\033]2;%s\033\\' "$1";tmux set -g pane-border-format "#{pane_index} #T"; }           # Name pane

# Python
##########
#alias python='python3'

# Vagrant
alias vu='vagrant up'
alias vh='vagrant halt'
alias vp='vagrant provision'
alias vd='vagrant destroy'

# Raspberry pi
alias vncAlexa='open vnc://pi@192.168.1.147:5901'

alias vl='vagrant global-status'

# Dev Shit
###########
alias bs='browser-sync start --server --files "**/*.*"'

# Shpotify
###########
alias sp='spotify play'
alias sn='spotify next'
alias spr='spotify previous'
alias ss='spotify status'
alias sst='spotify pause'

ssong() { spotify play song "$1" } # play song
salbum() { spotify play album "$1" } # play album
sartist() { spotify play artist "$1" } # play artist
slist() { spotify play list "$1" } # play list

# Tooling
alias localeslint='npm install --save-dev eslint eslint-plugin-react eslint-plugin-import eslint-plugin-jsx-a11y'

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