{self, ...}: {
  hm.imports = [
    self.homeModules.home
    self.homeModules.ags
    self.homeModules.alacritty
    self.homeModules.betterlockscreen
    self.homeModules.dunst
    self.homeModules.fish
    self.homeModules.git
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
    self.homeModules.tex
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

    {
      wayland.windowManager.hyprland = {
        settings.monitor = [
          "eDP-1,1920x1200@60.0,5120x640,1.5"
          "DP-1,5120x1440@59.98,0x0,1.0"
        ];
      };
    }
  ];
}
