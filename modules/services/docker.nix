{lib, pkgs, ...}: {
  virtualisation.docker = {
    enable = lib.mkDefault true;
    enableOnBoot = lib.mkDefault true;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
