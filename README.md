# My .dotfiles using NixOS's home-manager
## Install
Simply run the install script:
```bash
./install.sh
```

And you're done! Kind of, if you want to integrate home-manager's installed apps with the app menu you have to add the following to `~/.profile`
```bash
export XDG_DATA_DIRS="/home/goose/.nix-profile/share:$XDG_DATA_DIRS"
```
