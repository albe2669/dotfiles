{
  config,
  ...
}: {
  security = {
    polkit = enable;
    pam.services.greetd.enableGnomeKeyring = true;
  }

  services.gnome.gnome-keyring.enable = true;
}
