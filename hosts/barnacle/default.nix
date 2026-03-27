{
  self,
  config,
  ...
}: {
  imports = [
    # Configuration
    self.modules.combined.darwin-core
    self.modules.combined.shell
    self.modules.combined.docker

    # Home-only features
    self.modules.combined.home
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
    self.modules.combined.utils
    self.modules.combined.vscode
    self.modules.combined.work
    self.modules.combined.zen
    self.modules.combined.yazi
    self.modules.combined.spotify
    self.modules.combined.zellij
    self.modules.combined.wakatime
  ];

  networking.hostName = config.opts.info.name;
}
