_: {
  flake.modules.homeManager.yaak = {pkgs, ...}: {
    home.packages = with pkgs; [
      yaak
    ];
  };
}
