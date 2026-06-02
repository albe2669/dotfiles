{username, ...}: {
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  users.extraGroups.storage.members = [username];
}
