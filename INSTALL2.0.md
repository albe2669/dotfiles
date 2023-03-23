# Install
## Arch

## Libs
```
pacman -S python-virtualenv
```

## DE
```
pacman -S flameshot i3-wm rofi redshift polybar dunst brightnessctl

# For sddm
pacman -S sddm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg

sudo ln -s $PWD/sddm /etc/sddm.conf.d
sudo ln -s $PWD/sddm/themes/sugar-candy/theme.conf /usr/share/sddm/themes/sugar-candy/theme.conf
sudo ln -s $PWD/wallpaper/green_hills.jpg /usr/share/sddm/themes/sugar-candy/Backgrounds/green_hills.jpg
```

Download and install the sugar-candy theme from [here](https://store.kde.org/p/1312658)

### Lock screen
```
mkdir -p ~/Documents/AUR
cd ~/Documents/AUR
git clone https://aur.archlinux.org/i3lock-color.git
git clone https://aur.archlinux.org/betterlockscreen.git
cd i3lock-color
makepkg -s -i
cd ../betterlockscreen
makepkg -s -i
j dot
betterlockscreen -u ./wallpaper/green_hills.jpg
```

## Tools
```bash
pacman -S xclip neovim fish unzip tar ripgrep lazygit docker kubectl

# After go has been installed
go install github.com/gsamokovarov/jump@latest

# After rust has been installed
cargo install procs exa bandwhich bottom
```

## Langs
```bash
# Go
pacman -S go

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## Configs
### Natural scrolling
To fix natural scrolling in xorg add this to `/etc/X11/xorg.conf.d/40-libinput.conf` in the sections that has `MatchIsPointer "on"` or `MatchIsTouchpad "on"`
```
Option "NaturalScrolling" "True"
```

### Optimus-manager
Install with
```
cd ~/Documents/AUR/
git clone https://aur.archlinux.org/optimus-manager.git
cd optimus-manager
makepkg -s -i
j dot
sudo ln -s $PWD/optimus-manager/optimus-manager.conf /etc/optimus-manager/optimus-manager.conf
```

Something changed in xorg which means it requires a BusID to be set for each Device. optimus-manager does not do this so it must be added. Go to each file in `/etc/optimus-manager/xorg/**/*.conf` and add this to them:
```
# For integrated:
BusID "PCI:0:2:0"

# For nvidia
BusID "PCI:1:0:0"
```

### TLP
```
sudo ln -s $PWD/tlp/tlp.conf /etc/tlp.conf
```
