# ==============================================================================
# ZSH Configuration
# ==============================================================================

# ------------------------------------------------------------------------------
# Completions
# ------------------------------------------------------------------------------
fpath=(~/dotfiles/zsh "${fpath[@]}")
autoload -Uz utils tl kp ks vim tmuxify theme tea

# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------

# Editors
export EDITOR="$HOME/neovim/bin/nvim"
export REACT_EDITOR="$HOME/neovim/bin/nvim"

# FZF
export FZF_DEFAULT_OPTS="--height=50% --min-height=15 --reverse"
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Misc
export BAT_THEME="TwoDark"
export ERL_AFLAGS="-kernel shell_history enabled"
export PIP_REQUIRE_VIRTUALENV=true

# Build flags
export LDFLAGS="-L/usr/local/opt/readline/lib -L/usr/local/opt/openssl@3.2/lib -L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3.2/include -I/usr/local/opt/zlib/include"

# ------------------------------------------------------------------------------
# PATH Configuration
# ------------------------------------------------------------------------------
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

# Homebrew
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# Languages & Runtimes
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH="/usr/local/go/bin:$GOBIN:$PATH"

# ASDF
. ~/.asdf/plugins/java/set-java-home.zsh

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/29.0.2:$PATH"

# Tools
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export PATH="$HOME/.fastlane/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="/opt/apache-maven/bin:$PATH"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Dedupe PATH
typeset -U PATH fpath

# ------------------------------------------------------------------------------
# Aliases - Navigation
# ------------------------------------------------------------------------------
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# ------------------------------------------------------------------------------
# Aliases - Git
# ------------------------------------------------------------------------------
alias gs="git status -s | fzf --no-sort --reverse --preview 'git diff --color=always {+2} | diff-so-fancy' --bind=ctrl-j:preview-down --bind=ctrl-k:preview-up --preview-window=right:60%:wrap"
alias gr='git remote -v'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glogNoDays="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit"
alias ga='git add .'
alias gpush='git push --force-with-lease'
alias gpull='git pull'
alias gme='git config user.name "jim-at-jibba"'
alias workname="git config user.name 'James Best' && git config user.email 'james.best@reedr.co'"
alias gitname="git config user.name 'James Best' && git config user.email 'jim@justjibba.net'"
alias lg="lazygit"
alias epoc="date +%s | pbcopy"

# ------------------------------------------------------------------------------
# Aliases - General
# ------------------------------------------------------------------------------
alias v='NVIM_APPNAME=kick nvim'
alias l='eza --long --header --all --icons'
alias ls='eza --header'
alias tree='eza --tree --level=2'
alias c='clear'
alias cat='bat'
alias y="yazi"
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias lip="ip addr show en0"

# ------------------------------------------------------------------------------
# Aliases - Bluetooth
# ------------------------------------------------------------------------------
alias bton="blueutil -p 1"
alias btoff="blueutil -p 0"

# ------------------------------------------------------------------------------
# Aliases - Docker
# ------------------------------------------------------------------------------
alias ld="lazydocker"

# ------------------------------------------------------------------------------
# Aliases - Development
# ------------------------------------------------------------------------------
alias bs='npx browser-sync start --server --files "**/*.*"'
alias nmlist='find . -name "node_modules" -type d -prune -print | xargs du -chs'
alias nmdelete='find . -name "node_modules" -type d -prune -print -exec rm -rf "{}" \;'
alias love='open "$(basename "$PWD")" -a /Applications/love.app'
alias ft="rg -g '!./node_modules/**' -g '!./vendor/**' -g '!./ios' -g '*test*' --files | fzf | xargs yarn test --silent -i"

# ------------------------------------------------------------------------------
# Aliases - Fabric
# ------------------------------------------------------------------------------
alias up="cp -R ~/dotfiles/shellscripts/fabric/custompatterns/* ~/.config/fabric/patterns && echo 'Patterns updated!'"
alias p="pbpaste"

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------

yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

gpip() { PIP_REQUIRE_VIRTUALENV="" pip "$@"; }
gpip3() { PIP_REQUIRE_VIRTUALENV="" pip3 "$@"; }

pips() {
  local pkg=$1
  if [ -z "$1" ]; then
    echo "usage: pips <pkg name>"
    return 1
  fi
  pip install $pkg
  pip freeze | grep $pkg -i >> requirements.txt
}

# ------------------------------------------------------------------------------
# Tool Initialization
# ------------------------------------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"
# eval "$(pyenv init --path)"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"
eval "$(atuin init zsh)"
eval "$(zoxide init --cmd j zsh)"
eval "$(llm cmdcomp --init zsh)"
bindkey '^U' __llm_cmdcomp

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

