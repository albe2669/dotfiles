{
  self,
  inputs,
  config,
  ...
}: {
  imports = [
    # Configurations
    self.modules.combined.desktop
    self.modules.combined.laptop

    # NixOS features
    self.modules.combined.bootloader-uefi
    self.modules.combined.dynamic-libs
    self.modules.combined.touchpad
    self.modules.combined.bluetooth
    self.modules.combined.wireless
    self.modules.combined."1password"

    # Home-only features
    self.modules.combined.home
    self.modules.combined.ags
    self.modules.combined.azure-cli
    self.modules.combined.dunst
    self.modules.combined.fish
    self.modules.combined.git
    self.modules.combined.kitty
    self.modules.combined.lazydocker
    self.modules.combined.lazygit
    self.modules.combined.nvim
    self.modules.combined.sioyek
    self.modules.combined.wallpapers
    self.modules.combined.zathura
    self.modules.combined.langs
    self.modules.combined.python3
    self.modules.combined.tex
    self.modules.combined.anytype
    self.modules.combined.direnv
    self.modules.combined.gcloud
    self.modules.combined.libreoffice
    self.modules.combined.obs
    self.modules.combined.jetbrains
    self.modules.combined.jetbrains-phpstorm
    self.modules.combined.jetbrains-goland
    self.modules.combined.php
    self.modules.combined.guiutils
    self.modules.combined.utils
    self.modules.combined.vscode
    self.modules.combined.walker
    self.modules.combined.work
    self.modules.combined.zen
    self.modules.combined.yazi
    self.modules.combined.spotify
    self.modules.combined.zellij

    # Hardware
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-12th-gen
  ];

  hm.imports = [
    {
      wayland.windowManager.hyprland = {
        settings.monitor = [
          {
            output = "eDP-1";
            mode = "1920x1200@60.0";
            position = "5120x640";
            scale = 1.5;
          }
          {
            output = "DP-1";
            mode = "5120x1440@59.98";
            position = "0x0";
            scale = 1.0;
          }
        ];
      };
    }
  ];

  networking.hostName = config.opts.info.name;
}
