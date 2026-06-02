{config, ...}: {
  flake.modules.nixos.qemu = {
    username,
    pkgs,
    ...
  }: {
    programs.dconf.enable = true;

    users.extraGroups.libvirtd.members = [username];

    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      virtio-win # Renamed from win-virtio
      win-spice
      adwaita-icon-theme
    ];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
        };
      };
      spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;
  };

  flake.modules.combined.qemu = {...}: {
    imports = [config.flake.modules.nixos.qemu];
  };
}
