{
  category = "Software";
  name = "1password";

  nixos = {username, ...}: {
    programs._1password = {
      enable = true;
    };
    programs._1password-gui = {
      enable = true;
      # CLI integration and system authentication need PolKit on some desktops.
      polkitPolicyOwners = [username];
    };
  };

  darwin = _: {
    homebrew.casks = [
      "1password-cli"
    ];
  };
}
