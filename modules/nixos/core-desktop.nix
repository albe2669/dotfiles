{
  self,
  pkgs,
  ...
}: {
  imports = [
    # A desktop is just a server with better UX right?
    self.nixosModules.core-server

    self.nixosModules.pipewire
    self.nixosModules.printing
    self.nixosModules.storage
    self.nixosModules.security
    self.nixosModules.shell
    self.nixosModules.xdg

    self.nixosModules.fonts
    self.nixosModules.hyprland
    self.nixosModules.programs
    self.nixosModules.hidpi
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
