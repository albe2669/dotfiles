{config, ...}:
with config.opts; let
  username = variables.username;
in {
  nix.settings.trusted-users = [username];

  users.knownUsers = [username];

  users.users."${username}" = {
    home = "/Users/${username}";
    description = "User ${username}";
    uid = config.opts.variables.uid;
  };

  system.primaryUser = username;
}
