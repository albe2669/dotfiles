{self, ...}: {
  hm.imports = [
    self.homeModules.home
    self.homeModules.ags
    self.homeModules.azure-cli
    self.homeModules.dunst
    self.homeModules.fish
    self.homeModules.git
    self.homeModules.hyprland
    self.homeModules.kitty
    self.homeModules.lazydocker
    self.homeModules.lazygit
    self.homeModules.nvim
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
    self.homeModules.jetbrains-phpstorm
    self.homeModules.jetbrains-goland
    self.homeModules.php
    self.homeModules.programs
    self.homeModules.guiutils
    self.homeModules.utils
    self.homeModules.vscode
    self.homeModules.walker
    self.homeModules.work
    self.homeModules.zen
    self.homeModules.yazi
    self.homeModules.spotify
    self.homeModules.zellij

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
