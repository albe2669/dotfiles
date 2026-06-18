{
  self,
  config,
  ...
}: {
  imports = [
    # Configuration
    self.modules.combined.darwin-core
    self.modules.combined.shell
    self.modules.combined.mac-app-util
    self.modules.combined.docker
    self.modules.combined.aerospace

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
    self.modules.combined.direnv
    self.modules.combined.utils
    self.modules.combined.vscode
    self.modules.combined.work
    self.modules.combined.zen
    self.modules.combined.yazi
    self.modules.combined.spotify
    self.modules.combined.zellij
    self.modules.combined.wakatime
    self.modules.combined.k8
    self.modules.combined.azure-cli
    self.modules.combined.claude
    self.modules.combined."1password"
    self.modules.combined.git-widget
    self.modules.combined.wtf
    self.modules.combined.jetbrains
    self.modules.combined.jetbrains-goland
    self.modules.combined.rtk
    self.modules.combined.opencode
    self.modules.combined.omp
  ];

  system.keyboard = {
    enableKeyMapping = true;
    userKeyMapping = [
      {
        # ` -> §
        HIDKeyboardModifierMappingSrc = 30064771172;
        HIDKeyboardModifierMappingDst = 30064771125;
      }
      #{
      #  # § -> `
      #  HIDKeyboardModifierMappingSrc = 30064771125;
      #  HIDKeyboardModifierMappingDst = 30064771172;
      #}
    ];
  };

  networking.hostName = config.opts.info.name;
}
