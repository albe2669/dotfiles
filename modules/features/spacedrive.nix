{config, ...}: {
  flake.modules.homeManager.spacedrive = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
      spacedrive
    ];
  };

  flake.modules.combined.spacedrive = _: {
    hm.imports = [config.flake.modules.homeManager.spacedrive];
  };
}
