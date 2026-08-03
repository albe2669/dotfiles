{config, ...}: let
  flakeConfig = config;
in {
  flake.modules.nixos.docker = {pkgs, ...}: {
    environment.systemPackages = [pkgs.docker-compose];

    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  flake.modules.darwin.docker = {pkgs, ...}: {
    # homebrew.casks = [
    #   "docker-desktop"
    # ];

    environment.systemPackages = with pkgs; [
      docker-compose
      docker
      docker-credential-helpers
    ];
  };

  flake.modules.combined.docker = {system, ...}: let
    isDarwin = builtins.match ".*-darwin" system != null;
  in {
    imports = [
      (
        if isDarwin
        then flakeConfig.flake.modules.darwin.docker
        else flakeConfig.flake.modules.nixos.docker
      )
    ];
  };
}
