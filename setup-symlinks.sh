#!/bin/bash
set -euo pipefail

DOTFILES="$HOME/dotfiles"
CONFIG="$HOME/.config"
BACKUP_DIR=""

declare -a LINKS=(
	"kick:kick"
	"lazy-base:lazy-base"
	"gobang/config.toml:gobang/config.toml"
	"sketchybar:sketchybar"
	"nvim:nvim"
	"daily-driver:daily-driver"
	"spotify-player:spotify-player"
	"lazygit:lazygit"
	"wezterm/colors.lua:wezterm/colors.lua"
	"wezterm/wezterm.lua:wezterm/wezterm.lua"
	"wezterm/tab_bar.lua:wezterm/tab_bar.lua"
	"wezterm/key_bindings.lua:wezterm/key_bindings.lua"
	"starship.toml:starship/starship.toml"
	"skhd/skhdrc:skhdrc"
	"spacebar/spacebarrc:spacebar/spacebarrc"
	".lazycommit.yaml:lazycommit/.lazycommit.yaml"
	"yabai/yabairc:yabairc"
	"nvim-minimal:nvim-minimal"
	"min-vim:min-vim"
	"lazy:lazy"
	"kitty/kitty.conf:kitty.conf"
	"wtf/config.yml:wtf/config.yml"
	"ghostty/config:ghostty/config"
	"opencode/plugin:ai-stuff/opencode/plugin"
	"opencode/agent:ai-stuff/opencode/agent"
	"opencode/command:ai-stuff/opencode/command"
	"opencode/AGENTS.md:ai-stuff/opencode/AGENTS.md"
)

backup_item() {
	local item="$1"
	if [[ -z "$BACKUP_DIR" ]]; then
		BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
		mkdir -p "$BACKUP_DIR"
		echo "Created backup directory: $BACKUP_DIR"
	fi
	local relative="${item#$CONFIG/}"
	local backup_path="$BACKUP_DIR/$relative"
	mkdir -p "$(dirname "$backup_path")"
	mv "$item" "$backup_path"
	echo "  Backed up to: $backup_path"
}

create_symlink() {
	local target="$CONFIG/$1"
	local source="$DOTFILES/$2"

	if [[ -L "$target" ]]; then
		local current_target
		current_target=$(readlink "$target")
		if [[ "$current_target" == "$source" ]]; then
			echo "✓ $1 (already linked)"
			return
		fi
		echo "→ $1 (updating symlink)"
		rm "$target"
	elif [[ -e "$target" ]]; then
		echo "→ $1 (backing up existing)"
		backup_item "$target"
	else
		echo "→ $1 (creating)"
	fi

	mkdir -p "$(dirname "$target")"
	ln -s "$source" "$target"
}

echo "Setting up symlinks from $CONFIG -> $DOTFILES"
echo ""

for link in "${LINKS[@]}"; do
	target="${link%%:*}"
	source="${link#*:}"
	create_symlink "$target" "$source"
done

echo ""
echo "Done!"
if [[ -n "$BACKUP_DIR" ]]; then
	echo "Backups saved to: $BACKUP_DIR"
fi
