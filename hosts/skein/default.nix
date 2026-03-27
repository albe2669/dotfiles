{
  self,
  config,
  ...
}: let
  info = import ./info.nix;
in {
  imports = [
    # Configurations
    self.modules.combined.desktop
    self.modules.combined.laptop
    self.modules.combined.bluetooth

    # Home-only features
    self.modules.combined.home
    self.modules.combined.dunst
    self.modules.combined.fish
    self.modules.combined.git
    self.modules.combined.kitty
    self.modules.combined.lazygit
    self.modules.combined.nvim
    self.modules.combined.sioyek
    self.modules.combined.wallpapers
    self.modules.combined.zathura
    self.modules.combined.langs
    self.modules.combined.python3
    self.modules.combined.tex
    self.modules.combined.gcloud
    self.modules.combined.guiutils
    self.modules.combined.utils
    self.modules.combined.vscode

    # Hardware
    ./hardware-configuration.nix
    (import ./disko.nix {diskPath = info.diskPath;})
  ];

  networking.hostName = config.opts.info.name;
}
