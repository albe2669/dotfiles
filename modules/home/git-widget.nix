{
  inputs,
  config,
  lib,
  ...
}: {
  imports = [inputs.git-widget.homeManagerModules.default];

  programs.git-widget = {
    enable = true;

    github = {
      tokenFile = config.sops.secrets.gh_token.path;
    };

    repositories = [
    ];
  };
}
