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
      init.defaultBranch = "master";

      # https://blog.gitbutler.com/how-git-core-devs-configure-git/
      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      help.autocorrect = "prompt";

      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
    };

    lfs = {
      enable = true;
    };
  };
}
