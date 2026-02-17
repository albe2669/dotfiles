{self, ...}: {
  hm.imports = [
    self.homeModules.home
    self.homeModules.azure-cli
    self.homeModules.dunst
    self.homeModules.fish
    self.homeModules.git
    self.homeModules.hyprland
    self.homeModules.kitty
    self.homeModules.lazydocker
    self.homeModules.lazygit
    self.homeModules.nvim
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
    self.homeModules.ollama
    self.homeModules.opencode
    self.homeModules.jetbrains
    self.homeModules.php
    self.homeModules.programs
    self.homeModules.tmux
    self.homeModules.todo
    self.homeModules.guiutils
    self.homeModules.utils
    self.homeModules.vscode
    self.homeModules.walker
    self.homeModules.work
    self.homeModules.zen
    self.homeModules.yazi
    self.homeModules.spotify
    self.homeModules.zellij
    self.homeModules.wakatime

    {
      wayland.windowManager.hyprland = {
        settings = {
          monitor = [
            "DP-1,2560x1440@119.82,1080x213,1.0"
            "DP-2,1920x1080@59.95,3640x213,1.0"
            "HDMI-A-2,1920x1080@60.0,0x0,1.0,transform,3"
          ];

          workspace = [
            "1,monitor:DP-1,default:true"
            "2,monitor:DP-2,default:true"
            "9,monitor:HDMI-A-2,default:true"
          ];
        };
      };
    }
  ];
}
