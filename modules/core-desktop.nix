{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    # A desktop is just a server with better UX right?
    ./core-server.nix

    # services
    ./services/bluetooth.nix
    ./services/pipewire.nix
    ./services/power.nix
    ./services/printing.nix
    ./services/security.nix
    ./services/xdg.nix

    # configs
    ./configs/user-groups.nix
    ./configs/fonts.nix
    ./configs/i3.nix
		./configs/programs.nix
  ];

  nixpkgs.config.allowUnfree = lib.mkForce true;

  environment.shells = with pkgs; [
    bash
    fish
  ];

  users.defaultUserShell = pkgs.fish;

  environment.systemPackages = with pkgs; [
    parted
    (python3.withPackages (ps: 
      with ps; [ 
        # Add packages that need root here
      ]
    ))
    pulseaudio
  ];

  programs = {
    fish.enable = true;
    ssh.startAgent = true;
    dconf.enable = true;
  };

  services = {
    dbus.packages = [pkgs.gcr];
  };
}

