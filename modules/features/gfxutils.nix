{ config, ... }: {
  flake.modules.homeManager.gfxutils = {pkgs, ...}: {
    home.packages = with pkgs; [
      mesa-demos # Renamed from glxinfo
    ];
  };

  flake.modules.combined.gfxutils = { ... }: {
    hm.imports = [ config.flake.modules.homeManager.gfxutils ];
  };
}
