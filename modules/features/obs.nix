{ config, ... }: {
  flake.modules.homeManager.obs = { pkgs-unstable, ... }: {
    home.packages = with pkgs-unstable; [
      obs-studio
    ];
  };

  flake.modules.combined.obs = { ... }: {
    hm.imports = [ config.flake.modules.homeManager.obs ];
  };
}
