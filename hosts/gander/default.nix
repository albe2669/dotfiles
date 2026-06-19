{
  self,
  inputs,
  config,
  ...
}:
let
  info = import ./info.nix;
in
{
  imports = [
    # Configurations
    self.modules.combined.desktop
    self.modules.combined.laptop

    # NixOS features
    self.modules.combined.bootloader-uefi
    self.modules.combined.amd
    self.modules.combined.dynamic-libs
    self.modules.combined.qemu
    self.modules.combined.bluetooth

    # Home-only features
    self.modules.combined.home
    self.modules.combined.azure-cli
    self.modules.combined.claude
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
    self.modules.combined.anytype
    self.modules.combined.direnv
    self.modules.combined.gcloud
    self.modules.combined.libreoffice
    self.modules.combined.obs
    self.modules.combined.opencode
    self.modules.combined.jetbrains
    self.modules.combined.jetbrains-phpstorm
    self.modules.combined.php
    self.modules.combined.guiutils
    self.modules.combined.utils
    self.modules.combined.vscode
    self.modules.combined.walker
    # self.modules.combined.work
    self.modules.combined.zen
    self.modules.combined.yazi
    self.modules.combined.spotify
    self.modules.combined.zellij
    self.modules.combined.wakatime
    self.modules.combined.omp

    # Hardware
    ./hardware-configuration.nix
    (import ./disko.nix { diskPath = info.diskPath; })
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
  ];

  hm.imports = [
    {
      wayland.windowManager.hyprland = {
        settings = {
          monitorv2 = [
            {
              output = "DP-2";
              mode = "2560x1440@59.95";
              position = "1080x220";
              scale = "1.0";
            }
            {
              output = "HDMI-A-2";
              mode = "1920x1080@60.0";
              position = "0x0";
              scale = "1.0";
              transform = 3;
            }
          ];

          workspace_rule = [
            "1, monitor:DP-2, default:true"
            "9, monitor:HDMI-A-2, default:true"
          ];
        };
      };
    }
  ];

  networking.hostName = config.opts.info.name;
}
