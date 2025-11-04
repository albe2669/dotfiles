{username, ...}: {
  users.extraGroups.storage.members = [username];

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
}
