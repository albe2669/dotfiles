{
  category = "Tools";
  name = "utils";
  software = [
    "bat"
    "eza"
    "gnutar"
    "hyperfine"
    "ripgrep"
    "unzip"
    "gh"
    "gh-dash"
    "gnumake"
    "jq"
    "fd"
    "zoxide"
    "bandwhich"
    "bottom"
    "witr"
    "procs"
    "nix-output-monitor"
    "delta"
    "commitizen"
  ];

  homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      bat
      eza
      gnutar
      hyperfine
      ripgrep
      unzip
      gh
      gh-dash
      gnumake
      jq
      fd
      zoxide
      bandwhich
      bottom
      witr
      procs
      nix-output-monitor
      delta
      commitizen
    ];
  };
}
