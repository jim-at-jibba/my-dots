#!/bin/bash

# Updating packages
echo "Updating........"
sudo apt-get update

echo "Grabbing software for PPA's"
#### Add PPA software ###
apt-get install -y software-properties-common python-software-properties


echo "Adding all the PPA's"
### Grabbing all PPA's ###
add-apt-repository ppa:flexiondotorg/albert

echo "Updating"
### Update repos ###
apt-get update

echo "Install neovim........"
sudo apt-get install neovim python3-neovim

echo "Install others fzf etc......."
sudo apt-get install fzf ripgrep fonts-powerline exa bat tmux

echo "Setting up sane defaults for tmux......"
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf

echo "Getting vim config"
mkdir ~/$(USER)/dotfiles && cd $_

curl  https://raw.githubusercontent.com/jim-at-jibba/my-dots/master/nvim/init.vim --output init.vim
curl  https://raw.githubusercontent.com/jim-at-jibba/my-dots/master/tmux.conf --output tmux.conf

echo "Symlinking config"
ln -s ~/$(USER)/dotfiles/init.vim ~/.config/nvim
ln -s ~/$(USER)/dotfiles/tmux.config ~/.tmux.conf.local

echo "Installing Node"
sudo apt-get install curl software-properties-common
curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
sudo apt-get install nodejs
node -v

echo "Your all done, enjoy"
exit 0
