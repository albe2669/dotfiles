{
  category = "System software";
  name = "security";

  nixos = _: {
    security = {
      polkit.enable = true;
      pam.services.greetd.enableGnomeKeyring = true;

      sudo-rs.enable = true;
    };

    services.gnome.gnome-keyring.enable = true;
  };
}
