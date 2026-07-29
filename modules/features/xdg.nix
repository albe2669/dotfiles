{config, ...}: {
  flake.modules.nixos.xdg = {pkgs, ...}: {
    xdg = {
      portal = {
        enable = true;
        # Sets environment variable NIXOS_XDG_OPEN_USE_PORTAL to 1
        # This will make xdg-open use the portal to open programs,
        # which resolves bugs involving programs opening inside FHS envs or with unexpected env vars set from wrappers.
        # xdg-open is used by almost all programs to open an unknown file/uri
        # Rio as an example, it use xdg-open as default, but you can also custom this behavior
        # and vscode has open like `External Uri Openers`
        xdgOpenUsePortal = false;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];

        config.common.default = "*";
      };
    };
  };

  flake.modules.homeManager.xdg = {config, ...}: {
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
    };
  };

  # HM-only XDG setup. NixOS hosts that want the portal should import
  # flake.modules.nixos.xdg separately.
  flake.modules.combined.xdg = _: {
    hm.imports = [config.flake.modules.homeManager.xdg];
  };
}
