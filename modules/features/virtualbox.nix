{
  category = "System software";
  name = "virtualbox";

  nixos = {username, ...}: {
    virtualisation.virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };

    users.extraGroups.vboxusers.members = [username];
  };
}
