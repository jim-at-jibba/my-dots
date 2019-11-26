#!/bin/sh

# Homebrew Script for OSX
# To execute: save and `chmod +x ./brew-install-script.sh` then `./brew-install-script.sh`

echo "Starting bootstrapping"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# zsh
brew install zsh

PACKAGES=(
  git
  yarn
  postgresql
  ack
  autojump
  bat
  elixir
  ffmpeg
  fzf
  htop
  mongodb
  neovim
  netcat
  nmap
  reacttach-to-user-namespace
  redis
  ripgrep
  tmux
  wget
  youtube-dl
  zsh-completions
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup


echo "Installing cask..."
brew install caskroom/cask/brew-cask

CASKS=(
  firefox
  google-chrome
  google-drive
  iterm2
  postman
  alfred
  franz
  the-unarchiver
  1password
  android-studio
  gitkraken
  react-native-debugger
  spotify
  balenaetcher
  visual-studio-code
  inkdrop
  atext
)

echo "Installing cask apps..."
brew cask install ${CASKS[@]}

echo "Cleaning up casks..."
brew cask cleanup

echo "Linking alfred to apps..."
brew cask alfred link

echo "Configuring OSX..."

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

echo "Bootstrapping complete"
