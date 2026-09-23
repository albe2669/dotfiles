[
  {
    category = "Software";
    name = "jetbrains";

    homeManager = {
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
  }
  {
    category = "Software";
    name = "jetbrains-phpstorm";

    homeManager = import ./phpstorm.nix;
  }
  {
    category = "Software";
    name = "jetbrains-goland";

    homeManager = import ./goland.nix;
  }
]
