{config, ...}: {
  flake.modules.homeManager.git = {
    pkgs,
    config,
    ...
  }: let
    secrets = config.sops.secrets;
  in {
    home.packages = with pkgs; [
      bfg-repo-cleaner
      pre-commit
    ];

    programs.git = {
      enable = true;

      settings =
        {
          user = {
            name = config.opts.variables.git.username;
            email = config.opts.variables.git.email;
          };

          pull.rebase = true;
          init.defaultBranch = "master";

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
        }
        // {
          credential.helper =
            if secrets ? git_credentials.path
            then "store --file '${secrets.git_credentials.path}'"
            else "store";
        };

      lfs = {
        enable = true;
      };
    };
  };

  flake.modules.combined.git = {...}: {
    hm.imports = [config.flake.modules.homeManager.git];
  };
}
