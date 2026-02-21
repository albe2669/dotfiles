{config, ...}:
with config.opts; let
  username = variables.username;
in {
  nix.settings.trusted-users = [username];

  users.users."${username}" = {
    home = "/Users/${username}";
    description = "User ${username}";
  };

  system.primaryUser = username;
}
