#!/bin/bash

echo "Updating System"
#### My desktop ###
##start with update###
apt-get update

echo "Current Plank Version is below"
#### Plank current version ###
plank -V
sleep 5

echo "Grabbing software for PPA's"
#### Add PPA software ###
apt-get install -y software-properties-common python-software-properties


echo "Adding all the PPA's"
### Grabbing all PPA's ###
add-apt-repository -y ppa:ricotz/docky
add-apt-repository -y ppa:philip.scott/elementary-tweaks
add-apt-repository -y ppa:snwh/pulp
add-apt-repository -y ppa:noobslab/apps
add-apt-repository ppa:flexiondotorg/albert

echo "Updating"
### Update repos ###
apt-get update

echo "Installing all the new programs"
### Grabbign all the needed tools ###
apt-get install -y plank elementary-tweaks paper-gtk-theme paper-icon-theme plank-themer albert zsh tmux virtualbox git krita
cd /tmp/ && ./Replace.sh;cd

### Installing oh-my-zsh
echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Exiting new zsh shell to continue install
exit
### Installing NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

### Pulling my dotfiles



### new Plank version ###
echo "New Plank version is below"
plank -V
sleep 5
echo "Your all done, enjoy"
echo "Please run (plank --preferences)"
killall plank
exit 0
