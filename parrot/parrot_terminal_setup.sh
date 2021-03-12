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
sudo apt-get install fzf tmux terminator

echo "Installing ripgrep"
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
sudo dpkg -i ripgrep_11.0.2_amd64.deb

echo "Installing bat"
curl -LO https://github.com/sharkdp/bat/releases/download/v0.13.0/bat_0.13.0_amd64.deb
sudo dpkg -i bat_0.13.0_amd64.deb

echo "Installing vim plug......"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Setting up sane defaults for tmux......"
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf

echo "Getting vim config"
mkdir ~/$(USER)/dotfiles && cd $_

curl  https://raw.githubusercontent.com/jim-at-jibba/my-dots/master/nvim/init.vim --output init.vim
curl  https://raw.githubusercontent.com/jim-at-jibba/my-dots/master/tmux.conf --output tmux.conf

echo "Symlinking config"
ln -s ~/dotfiles/init.vim ~/.config/nvim/init.vim
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf.local

echo "Installing Node"
sudo apt-get install curl software-properties-common
curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
sudo apt-get install nodejs
node -v

echo "Your all done, enjoy"
exit 0
