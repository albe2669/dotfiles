{config, ...}: {
  flake.modules.homeManager.git-widget = {
    inputs,
    config,
    ...
  }: {
    imports = [inputs.git-widget.homeManagerModules.default];

    programs.git-widget = {
      enable = true;

      github = {
        tokenFile = config.sops.secrets.gh_token.path;
      };

      repositories = [];
    };
  };

  flake.modules.combined.git-widget = {...}: {
    hm.imports = [config.flake.modules.homeManager.git-widget];
  };
}
