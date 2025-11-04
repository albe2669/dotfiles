{self, ...}: {
  hm.imports = [
    self.homeModules.home
    self.homeModules.alacritty
    self.homeModules.azure-cli
    self.homeModules.betterlockscreen
    self.homeModules.dunst
    self.homeModules.fish
    self.homeModules.git
    self.homeModules.hpgp
    self.homeModules.hyprland
    self.homeModules.kitty
    self.homeModules.lazydocker
    self.homeModules.lazygit
    self.homeModules.nvim
    self.homeModules.polybar
    self.homeModules.rofi
    self.homeModules.sioyek
    self.homeModules.wallpapers
    self.homeModules.zathura
    self.homeModules.langs
    self.homeModules.python3
    # self.homeModules.tex
    self.homeModules.anytype
    self.homeModules.bluetooth
    self.homeModules.direnv
    self.homeModules.gcloud
    self.homeModules.hidpi
    self.homeModules.libreoffice
    self.homeModules.obs
    self.homeModules.jetbrains
    self.homeModules.php
    self.homeModules.programs
    self.homeModules.tmux
    self.homeModules.todo
    self.homeModules.guiutils
    self.homeModules.utils
    self.homeModules.vscode
    self.homeModules.work
    self.homeModules.zen
    self.homeModules.yazi
    self.homeModules.spicetify

    {
      wayland.windowManager.hyprland = {
        settings.monitor = [
          "HDMI-A-1,1920x1080@60.0,2560x0,1.0"
          "DP-3,2560x1440@59.95,0x0,1.0"
        ];
      };
    }
  ];
}
