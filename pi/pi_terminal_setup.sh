#!/bin/bash

# Updating packages
echo "Updating........"
sudo apt-get update

echo "Updating"
### Update repos ###
apt-get update

echo "Install git........"
sudo apt-get install git

echo "Install neovim........"
sudo apt-get install neovim python3-neovim

echo "Install others fzf etc......."
sudo apt-get install fzf tmux ripgrep

echo "Installing vim plug......"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Setting up sane defaults for tmux......"
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf

echo "Setting up Go..."
mkdir ~/src && cd ~/src
wget https://golang.org/dl/go1.15.11.linux-armv6l.tar.gz

echo "Getting vim config"
mkdir ~/$(USER)/dotfiles && cd $_

curl  https://raw.githubusercontent.com/jim-at-jibba/my-dots/master/parrot/init.vim --output init.vim
curl  https://raw.githubusercontent.com/jim-at-jibba/my-dots/master/tmux.conf --output tmux.conf

mkdir -p ~/.config/nvim

echo "Symlinking config"
ln -s ~/dotfiles/init.vim ~/.config/nvim/init.vim
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf.local

echo "Installing Node"
sudo apt-get install nodejs
node -v
npm -v

echo "Your all done, enjoy"
exit 0
