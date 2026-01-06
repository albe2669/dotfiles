{...}: {
  programs = {
    ssh.startAgent = false;  # Disabled due to conflict with services.gnome.gcr-ssh-agent
    dconf.enable = true;
  };
}
