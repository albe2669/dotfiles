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

base_config_directory="$HOME/.config"

# Config directory, where config files without specific locations are stored
config_directory="$base_config_directory/dotfiles"
if [ ! -d "$config_directory" ]; then
    log "Creating $config_directory directory"

    mkdir -p "$config_directory"

    log "Directory created"
fi


# Shell themes
theme_path="$config_directory/poshthemes"
if test_symbolic_link "$theme_path"; then
    log "Creating $theme_path directory"
    
    ln -s "$PWD/poshthemes" "$theme_path"
    
    log "Symbolic link created"
fi


# Nvim
nvim_path="$base_config_directory/nvim"
if test_symbolic_link "$nvim_path"; then
    log "Creating $nvim_path directory"

    ln -s "$PWD/nvim" "$nvim_path"

    log "Symbolic link created"
fi


# Lazy git
lazy_git_path="$base_config_directory/lazygit"
if test_symbolic_link "$lazy_git_path"; then
    log "Creating $lazy_git_path directory"

    ln -s "$PWD/lazygit" "$lazy_git_path"

    log "Symbolic link created"
fi
