{self, ...}: {
  hm.imports = [
    self.homeModules.home
    self.homeModules.fish
    self.homeModules.git
    self.homeModules.lazygit
    self.homeModules.nvim
    self.homeModules.direnv
    self.homeModules.tmux
    self.homeModules.utils
    self.homeModules.yazi
    self.homeModules.zellij
  ];
}
