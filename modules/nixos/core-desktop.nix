{
  lib,
  pkgs,
  variables,
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
    ./configs/hyprland.nix
    ./configs/programs.nix
    ./configs/hidpi.nix
  ];

  environment.systemPackages = with pkgs; [
    parted
    (python3.withPackages (
      ps:
        with pkgs; [
          # Add packages that need root here
        ]
    ))
  ];

  services = {
    dbus.packages = [pkgs.gcr];
  };
}
