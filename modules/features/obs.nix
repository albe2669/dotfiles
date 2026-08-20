_: {
  flake.modules.homeManager.obs = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
      obs-studio
    ];
  };
}
