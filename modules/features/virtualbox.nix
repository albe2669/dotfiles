{config, ...}: {
  flake.modules.nixos.virtualbox = {username, ...}: {
    virtualisation.virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };

    users.extraGroups.vboxusers.members = [username];
  };

  flake.modules.combined.virtualbox = {...}: {
    imports = [config.flake.modules.nixos.virtualbox];
  };
}
