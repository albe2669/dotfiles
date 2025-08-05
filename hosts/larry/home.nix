{self, ...}: {
  imports = [
    self.homeModules.home
    self.homeModules.fish
    self.homeModules.git
    self.homeModules.lazydocker
    self.homeModules.lazygit
    self.homeModules.yazi
    self.homeModules.nvim
    self.homeModules.fonts
    self.homeModules.langs
    self.homeModules.python3
    self.homeModules.direnv
    self.homeModules.tmux
    self.homeModules.utils
  ];

  programs.git.extraConfig.safe.directory = [
    "/mnt/c/Users/AlbertRiseNielsen/Coding/Man-in-the-Middle"
    "/mnt/c/Users/AlbertRiseNielsen/Coding/Man-in-the-Middle/*"
  ];
}
