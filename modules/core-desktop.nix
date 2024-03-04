{
  lib,
  pkgs,
  ...
}: {
  imports = [
    # A desktop is just a server with better UX right?
    ./core-server.nix

    # services
    ./services/pipewire.nix
    ./services/printing.nix
    ./services/security.nix
    ./services/shell.nix
    ./services/xdg.nix

    # configs
    ./configs/fonts.nix
    ./configs/i3.nix
    ./configs/programs.nix
    ./configs/user-groups.nix
  ];

  nixpkgs.config.allowUnfree = lib.mkForce true;

  environment.systemPackages = with pkgs; [
    parted
    (python3.withPackages (
      ps:
        with pkgs; [
          # Add packages that need root here
        ]
    ))
    pulseaudio
  ];

  services = {
    dbus.packages = [pkgs.gcr];
  };
}
