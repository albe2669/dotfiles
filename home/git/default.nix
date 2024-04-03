{
  pkgs,
  consts,
  ...
}: {
  home.packages = with pkgs; [
    bfg-repo-cleaner
  ];

  programs.git = {
    enable = true;
    userName = consts.git.username;
    userEmail = consts.git.username;

    extraConfig = {
      pull.rebase = false;
      credential.helper = "store";
    };

    lfs = {
      enable = true;
    };
  };
}
