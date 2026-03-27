{ config, ... }: {
  flake.modules.homeManager.anytype = { pkgs-unstable, ... }: {
    home.packages = with pkgs-unstable; [
      anytype
    ];
  };

  flake.modules.combined.anytype = { ... }: {
    hm.imports = [ config.flake.modules.homeManager.anytype ];
  };
}
