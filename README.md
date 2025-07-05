# My Dots

When setting up a new computer dont forget to install the following:

To symlink snippets `ln -s ~/dotfiles/snippets/* ~/.vim/snippets`
To symlink neovim `ln -s ~/dotfiles/nvim/* ~/.config/nvim`
Symlink alacritty `ln -s ~/dotfiles/alacritty.yml ~/.config/alacritty`

## TMUX

Most of the set up is done with this guys setup

```bash
git clone https://github.com/gpakosz/.tmux.git

ln -s -f .tmux/.tmux.conf

ln -s ~/dotfiles/tmux.conf  ~/.tmux.conf.local
```
Test terminal italic support

```bash
echo -e "\e[1mbold\e[0m"
echo -e "\e[3mitalic\e[0m"
echo -e "\e[4munderline\e[0m"
echo -e "\e[9mstrikethrough\e[0m"
echo -e "\e[31mHello World\e[0m"
```
Show current fonts in kitty `kitty --debug-font-fallback`

## Brew

- autojump
- bat
- broot
- diff-so-fancy
- elixir
- exa
- fzf
- htop
- httpie
- iproute2mac
- jq
- kubernetes-cli
- lazydocker
- lazygit
- neovim
- magic-worm


## NPM

- navy
- n

## Programs

- Adobe
- alfred
- android studio
- anki
- aText
- etcher
- color picker
- docker
- gitkraken
- helium
- iterm
- Microsoft todo
- moom
- MQTT.fx
- Notion
- pgAdmin
- Postman
- RN debugger
- Robo
- Rocket
- sequelPro
- Source note
- spotify
- vscode
- VLC
- Vysor
- pock
