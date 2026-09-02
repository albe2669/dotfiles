{
  self,
  config,
  ...
}: {
  imports = with self.modules.combined; [
    # Configurations
    server

    # Core
    shell
    wsl
    docker
    xdg

    # NixOS features
    dynamic-libs

    # Home-only features
    home
    fish
    git
    lazydocker
    lazygit
    nvim
    langs
    python3
    direnv
    utils
    yazi
    herdr
    wakatime
    rtk
    opencode
    omp
    ai
    tailscale
  ];

  networking.hostName = config.opts.info.name;
}
