{
  category = "System software";
  name = "docker";
  software = ["docker-compose" "docker" "docker-credential-helpers"];

  nixos = {pkgs, ...}: {
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

  darwin = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      docker-compose
      docker
      docker-credential-helpers
    ];
  };
}
