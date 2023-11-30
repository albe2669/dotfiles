{pkgs, ...}: {
  home.packages = with pkgs; [
    bfg-repo-cleaner
  ];

  programs.git = {
    enable = true;
    userName = "albe2669";
    userEmail = "albert@risenielsen.dk";

    extraConfig = {
      pull.rebase = false;
      credential.helper = "store";
    };

    lfs = {
      enable = true;
    };
  };
}
