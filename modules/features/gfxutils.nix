{config, ...}: {
  flake.modules.homeManager.gfxutils = {pkgs, ...}: {
    home.packages = with pkgs; [
      mesa-demos # Renamed from glxinfo
    ];
  };

  flake.modules.combined.gfxutils = _: {
    hm.imports = [config.flake.modules.homeManager.gfxutils];
  };
}
