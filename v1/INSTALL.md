# Install
## General

### Install i3
```
sudo apt install flameshot rofi redshift
```

Also install
- Polybar
- i3-gaps

### Firefox 
#### Setup sync
#### Dashlane
Get it from `https://dashlane.com/download`

## Gnome
### Natural scrolling
```
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
```

### Terminal opacity
Set opacity on gnome terminal

### gnome-tweaks
```
sudo apt install gnome-tweaks
```
Install https://extensions.gnome.org/extension/19/user-themes/

### Theme
#### Everforest
https://www.gnome-look.org/p/1695467/

```
cd <where-they-are-located>

# Gnome 40 and 41
# Should be applied in gnome-tweaks
mkdir -p ~/.themes/
unzip Everforest-Dark-B.zip -d ~/.themes
unzip Everforest-Dark-BL.zip -d ~/.themes

# Gnome 42
mkdir -p ~/.config/gtk-4.0
unzip Everforest-Dark-B-Gnome-42.zip -d ~/.config/gtk-4.0
unzip Everforest-Dark-BL-Gnome-42.zip -d ~/.config/gtk-4.0
```

## Dotfiles
### Download and install
```
mkdir -p ~/Documents/Coding/other
cd ~/Documents/Coding/other
git clone https://github.com/albe2669/dotfiles
cd dotfiles
./install.sh
```

### Install fish
#### Install fish
```
sudo apt install fish
chsh -s $(which fish)

# Install fisher
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

# Plugins
fisher install FabioAntunes/fish-nvm edc/bass
```

Logout and log back in to save changes

### NVIM
```
# Install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

nvim -c PlugInstall

# Mason Dependencies
sudo apt update
sudo apt install python3 python3-venv
```

### fira-code
Download font, then to use it in the terminal:
```
dconf dump /org/gnome/terminal/legacy/profiles:/
# Get the profile id from the output
dconf write /org/gnome/terminal/legacy/profiles:/<profile-id>/font "'FiraCode Nerd Font Regular 12'"
```

## LSPs
### Lua
Get from https://github.com/sumneko/lua-language-server/releases
```
tar -xzf <file>
```

### Clang
```
sudo apt install clangd-14
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-14 100
```

### JS
```
npm install -g typescript typescript-language-server vscode-langservers-extracted prettier
```

### Python
```
python3 -m pip install pyright
```

### YAML
```
npm install -g yaml-language-server
```

### Go
```
go install golang.org/x/tools/gopls@latest
```

## Apps
- Install discord
  - Can be done through the pop-shop
- Install slack
  - Can be done through the pop-shop

## Other stuff
```
sudo apt update
sudo apt full-upgrade
```

