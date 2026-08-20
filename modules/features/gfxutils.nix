_: {
  flake.modules.homeManager.gfxutils = {pkgs, ...}: {
    home.packages = with pkgs; [
      mesa-demos # Renamed from glxinfo
    ];
  };
}
