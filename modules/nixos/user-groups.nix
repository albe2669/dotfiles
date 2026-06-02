{config, ...}:
with config.opts; let
  username = variables.username;
  secrets = config.sops.secrets;
in {
  nix.settings.trusted-users = [username];

  users.groups = {
    "${username}" = {};
    docker = {};
  };

  users.users."${username}" = {
    home = "/home/${username}";
    hashedPasswordFile = secrets.password.path;
    createHome = true;
    isNormalUser = true;
    description = "User ${username}";
    extraGroups = [
      username
      "docker"
      "wheel"
      "networkmanager"
      "libvirtd"
    ];
  };

  security.sudo.extraRules = [
    {
      users = [username];
      commands = [
        {
          command = "/run/current-system/sw/bin/nix-store";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/nix-copy-closure";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
