_: {
  flake.modules.nixos.virtualbox = {username, ...}: {
    virtualisation.virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };

    users.extraGroups.vboxusers.members = [username];
  };
}
