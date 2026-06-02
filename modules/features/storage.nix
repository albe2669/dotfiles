{config, ...}: {
  flake.modules.nixos.storage = {username, ...}: {
    services.devmon.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    users.extraGroups.storage.members = [username];
  };

  flake.modules.combined.storage = {...}: {
    imports = [config.flake.modules.nixos.storage];
  };
}
