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
}
