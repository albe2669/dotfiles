{config, ...}: {
  flake.modules.nixos.security = {...}: {
    security = {
      polkit.enable = true;
      pam.services.greetd.enableGnomeKeyring = true;

      sudo-rs.enable = true;
    };

    services.gnome.gnome-keyring.enable = true;
  };

  flake.modules.combined.security = {...}: {
    imports = [config.flake.modules.nixos.security];
  };
}
