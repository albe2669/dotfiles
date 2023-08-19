#!/bin/bash
# Install nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# Add channels 
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

# Update channels
nix-channel --update

# Install home manager
nix-shell '<home-manager>' -A install

# Link home manager config
ln -s $PWD ~/.config/home-manager

# Link nix config
mkdir -p ~/.config/nixpkgs
ln -s $PWD/config.nix ~/.config/nixpkgs/config.nix

# Switch to the config
home-manager switch

# Do the changes to the system that cause fish to work
# Add fish to /etc/shells

# Change the default shell
