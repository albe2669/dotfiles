_: {
  flake.modules.homeManager.spacedrive = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
      spacedrive
    ];
  };
}
