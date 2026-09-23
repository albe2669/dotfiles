{
  category = "System software";
  name = "power";
  software = ["powertop"];

  nixos = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      powertop
    ];

    powerManagement = {
      enable = lib.mkDefault true;
    };
  };
}
