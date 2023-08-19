#!/bin/sh

# Write to console function
log()
{
    echo "$1"
}

test_symbolic_link() {
    # If file exists and is a symbolic link return true
    if [ -d "$1" ] || [ -f "$1" ]; then
        if [ ! -L "$1" ]; then
            log "The $1 file exists and is not a symbolic link. Skipping" 
        fi

        return 1
    fi

    return 0
}

create_directory() {
  target_dir=$1

  if [ ! -d "$target_dir" ]; then
    log "Creating $target_dir directory"

    mkdir -p "$target_dir"

    log "directory created"
  fi
}

create_link() {
  target_loc=$1
  local_loc=$2

  if test_symbolic_link "$1"; then
    log "Creating $1 link"

    ln -s "$PWD/$local_loc" "$target_loc"

    log "Symbolic link created"
  fi
}

base_config_directory="$HOME/.config"

# Config directory, where config files without specific locations are stored
config_directory="$base_config_directory/dotfiles"
create_directory "$config_directory"

# Shell themes
theme_path="$config_directory/poshthemes"
create_link "$theme_path" "poshthemes"

# TODO: Run these as root
# sudo ln -s "$PWD/fish/bin_files" "/usr/local/bin/node"

# Picom
picom_path="$base_config_directory/picom"
create_link "$picom_path" "picom"

# I3
i3_path="$base_config_directory/i3"
create_link "$i3_path" "i3"

# betterlockscreen
betterlockscreen_path="$base_config_directory/betterlockscreenrc"
create_link "$betterlockscreen_path" "betterlockscreen/betterlockscreenrc"

# Polybar
polybar_path="$base_config_directory/polybar"
create_link "$polybar_path" "polybar"

# Alacritty
alacritty_path="$base_config_directory/alacritty"
create_link "$alacritty_path" "alacritty"

# Rofi
rofi_path="$base_config_directory/rofi"
create_link "$rofi_path" "rofi"

# Dunst
dunst_path="$base_config_directory/dunst"
create_link "$dunst_path" "dunst"
