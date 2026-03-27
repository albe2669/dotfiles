{ config, ... }: {
  flake.modules.homeManager.direnv = { ... }: {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      # fish = {
      #   shellInit = ''
      #     direnv hook fish | source
      #   '';
      # };
    };
  };

  flake.modules.combined.direnv = { ... }: {
    hm.imports = [ config.flake.modules.homeManager.direnv ];
  };
}
