{config, ...}: {
  flake.modules.homeManager.satty = {
    pkgs-unstable,
    config,
    ...
  }: {
    home.packages = with pkgs-unstable; [
      satty
    ];

    xdg.configFile."satty/config.toml".source = (pkgs-unstable.formats.toml {}).generate "something" {
      general = {
        fullscreen = true;
        output-filename = config.opts.variables.homeDirectory.path + (builtins.toPath "/Pictures/Screenshots/%Y-%m-%d_%H:%M:%S.png");
        save-after-copy = true;
      };
    };
  };

  flake.modules.combined.satty = {...}: {
    hm.imports = [config.flake.modules.homeManager.satty];
  };
}
