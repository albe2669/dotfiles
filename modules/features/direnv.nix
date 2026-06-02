{config, ...}: {
  flake.modules.homeManager.direnv = {pkgs, ...}: {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        package = pkgs.direnv.overrideAttrs {doCheck = false;};
      };

      # fish = {
      #   shellInit = ''
      #     direnv hook fish | source
      #   '';
      # };
    };
  };

  flake.modules.combined.direnv = {...}: {
    hm.imports = [config.flake.modules.homeManager.direnv];
  };
}
