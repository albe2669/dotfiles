{config, ...}: {
  flake.modules.combined.desktop = {pkgs, ...}: {
    imports = with config.flake.modules.combined; [
      server
      pipewire
      shell
      fonts
      hyprland
      hidpi
      security
      storage
      xdg
      programs
    ];

    environment.systemPackages = with pkgs; [
      parted
      (python3.withPackages (
        ps:
          with pkgs; [
          ]
      ))
    ];

    services = {
      dbus.packages = [pkgs.gcr];
    };
  };
}
