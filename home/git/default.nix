{
  pkgs,
  variables,
  ...
}: {
  home.packages = with pkgs; [
    bfg-repo-cleaner
  ];

  programs.git = {
    enable = true;
    userName = variables.git.username;
    userEmail = variables.git.email;

    extraConfig = {
      pull.rebase = false;
      credential.helper = "store";
    };

    lfs = {
      enable = true;
    };
  };
}
