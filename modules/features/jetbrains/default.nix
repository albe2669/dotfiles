{config, ...}: {
  flake.modules.homeManager.jetbrains = {
    config,
    lib,
    ...
  }: {
    xdg.configFile."ideavim/ideavimrc" = {
      text =
        (builtins.readFile ./config/ideavimrc)
        + lib.optionalString config.opts.variables.isDarwin (builtins.readFile ./config/ideavimrc-darwin);
    };
  };

  flake.modules.homeManager.jetbrains-phpstorm = import ./phpstorm.nix;
  flake.modules.homeManager.jetbrains-goland = import ./goland.nix;

  flake.modules.combined.jetbrains-phpstorm = _: {
    hm.imports = [config.flake.modules.homeManager.jetbrains-phpstorm];
  };

  flake.modules.combined.jetbrains-goland = _: {
    hm.imports = [config.flake.modules.homeManager.jetbrains-goland];
  };
}
