{
  pkgs-unstable,
  username,
  ...
}: {
  programs._1password = {
    enable = true;
    # pkg = pkgs-unstable._1password;
  };
  programs._1password-gui = {
    enable = true;
    # pkg = pkgs-unstable._1password-gui;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [username];
  };
}
