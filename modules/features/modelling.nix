_: {
  flake.modules.homeManager.modelling = {pkgs, ...}: {
    home.packages = with pkgs; [
      freecad
    ];
  };
}
