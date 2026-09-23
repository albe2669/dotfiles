{
  category = "System software";
  name = "xdg";

  nixos = {pkgs, ...}: {
    xdg = {
      portal = {
        enable = true;
        # xdg-open uses the portal to open programs, which resolves bugs
        # involving programs opening inside FHS envs or with unexpected env vars
        # from wrappers
        xdgOpenUsePortal = false;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];

        config.common.default = "*";
      };
    };
  };

  homeManager = {config, ...}: {
    xdg.enable = true;

    home.sessionVariables = {
      # Azure CLI
      AZURE_CONFIG_DIR = "${config.xdg.configHome}/azure";

      # Docker CLI (Docker Desktop may still use ~/.docker on macOS)
      DOCKER_CONFIG = "${config.xdg.configHome}/docker";

      # Rust Cargo — data, not config (registry, bin, git checkouts)
      CARGO_HOME = "${config.xdg.dataHome}/cargo";

      # npm — cache only
      npm_config_cache = "${config.xdg.cacheHome}/npm";

      # Bun — install dir (contains bin/, install/cache)
      BUN_INSTALL = "${config.xdg.dataHome}/bun";

      # GitHub Copilot CLI
      COPILOT_HOME = "${config.xdg.configHome}/copilot";

      # IPython
      IPYTHONDIR = "${config.xdg.configHome}/ipython";

      # WakaTime — both config and data
      WAKATIME_HOME = "${config.xdg.configHome}/wakatime";

      # Go Delve debugger
      DLV_CONFIG_DIR = "${config.xdg.configHome}/dlv";

      # omp — MUST be relative: omp does path.join(os.homedir(), PI_CONFIG_DIR)
      PI_CONFIG_DIR = ".config/omp";

      KUBECONFIG = "${config.xdg.configHome}/kube/config";
    };
  };
}
