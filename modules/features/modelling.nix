{config, ...}: {
  flake.modules.homeManager.modelling = {pkgs, ...}: {
    home.packages = with pkgs; [
      freecad
    ];
  };

  flake.modules.combined.modelling = {...}: {
    hm.imports = [config.flake.modules.homeManager.modelling];
  };
}
