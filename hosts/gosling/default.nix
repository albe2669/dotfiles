{
  self,
  inputs,
  config,
  lib,
  ...
}: let
  info = import ./info.nix;
in {
  imports = [
    # Configurations
    self.modules.combined.desktop
    self.modules.combined.laptop

    # NixOS features
    self.modules.combined.bootloader-uefi
    self.modules.combined.nvidia
    self.modules.combined.nvidia-prime
    self.modules.combined.dynamic-libs
    self.modules.combined.touchpad
    self.modules.combined.bluetooth
    self.modules.combined.qemu
    # self.modules.combined.tailscale
    self.modules.combined.wireless

    # Home-only features
    self.modules.combined.home
    self.modules.combined.advent-of-code
    self.modules.combined.ags
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
    self.modules.combined.modelling
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
    (import ./disko.nix {diskPath = info.diskPath;})
    inputs.nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
  ];

  opts.variables.isHidpi = lib.mkForce true;
  hm.imports = [
    {
      opts.variables.isHidpi = lib.mkForce true;
    }
  ];

  networking.hostName = config.opts.info.name;
}
