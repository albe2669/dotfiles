{config, ...}: {
  flake.modules.homeManager.obs = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
      obs-studio
    ];
  };

  flake.modules.combined.obs = _: {
    hm.imports = [config.flake.modules.homeManager.obs];
  };
}
