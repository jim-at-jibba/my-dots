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
  asdf
  atuin
  bat
  btop
  bun
  cmake
  curl
  diff-so-fancy
  docker-compose
  elixir
  erlang
  exa
  fastlane
  fd
  ffmpeg
  fmt
  fnm
  fzf
  gemini-cli
  gh
  git-delta
  gtop
  httpie
  jq
  just
  lazydocker
  lazygit
  lua
  lua-language-server
  luarocks
  llm
  magic-wormhole
  maven
  pidcat
  pnpm
  prettierd
  rgbds
  ripgrep
  speedtest-cli
  sqlite
  starship
  stylua
  thefuck
  tree
  watchman
  webp
  wget
  yq
  yt-dlp
  zellij
  zoxide
)

CASKS=(
  ghostty
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Installing cask apps..."
brew install --cask ${CASKS[@]}

echo "Cleaning up..."
brew cleanup


# echo "Installing cask..."
# brew install caskroom/cask/brew-cask

# CASKS=(
#   firefox
#   google-chrome
#   google-drive
#   iterm2
#   postman
#   alfred
#   franz
#   the-unarchiver
#   1password
#   android-studio
#   gitkraken
#   react-native-debugger
#   spotify
#   balenaetcher
#   visual-studio-code
#   inkdrop
#   atext
# )

# echo "Installing cask apps..."
# brew cask install ${CASKS[@]}

# echo "Cleaning up casks..."
# brew cask cleanup

# echo "Linking alfred to apps..."
# brew cask alfred link

# echo "Configuring OSX..."

# # Set fast key repeat rate
# defaults write NSGlobalDomain KeyRepeat -int 0

echo "Bootstrapping complete"
