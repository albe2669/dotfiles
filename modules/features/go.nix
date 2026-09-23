{
  category = "Programming languages";
  name = "go";
  software = [
    "go"
    "golangci-lint"
    "gopls"
  ];

  homeManager = {pkgs-unstable, ...}: let
    go_pkg = pkgs-unstable.go_1_26;
  in {
    home.packages = [
      go_pkg
      pkgs-unstable.golangci-lint
      pkgs-unstable.gopls
    ];

    programs.fish.shellInit = ''
      set -x GOROOT "${go_pkg}/share/go"
    '';

    home.sessionVariables = {
      GOROOT = "${go_pkg}/share/go";
    };
  };
}
