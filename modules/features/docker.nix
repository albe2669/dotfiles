_: {
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
}
