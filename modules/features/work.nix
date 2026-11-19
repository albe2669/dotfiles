{
  category = "Tools";
  name = "work";
  software = [
    "bruno"
    "bruno-cli"
    "slack"
  ];

  homeManager = {
    pkgs-unstable,
    pkgs,
    lib,
    ...
  }: {
    home.packages = with pkgs-unstable; [
      bruno
      bruno-cli
      slack
    ];

    programs.fish.interactiveShellInit = ''
      set -x GIT_TOKEN (${lib.getExe pkgs.gh} auth token)
      set -x GOPRIVATE "github.com/corticph/*"
    '';

    programs.git.settings = {
      credential."https://github.com".helper = "!${lib.getExe pkgs.gh} auth git-credential";
      url."https://github.com/corticph" = {
        insteadOf = [
          "https://github.com/corticph"
          "ssh://git@github.com/corticph"
        ];
      };
    };
  };
}
