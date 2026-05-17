{config, ...}: {
  flake.modules.homeManager.spacedrive = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
      spacedrive
    ];
  };

  flake.modules.combined.spacedrive = {...}: {
    hm.imports = [config.flake.modules.homeManager.spacedrive];
  };
}
