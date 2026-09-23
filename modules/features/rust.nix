{
  category = "Programming languages";
  name = "rust";
  software = [
    "cargo"
    "rustc"
    "rustfmt"
    "clippy"
    "rust-analyzer"
    "delve"
    "gdb"
  ];

  homeManager = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
      cargo
      rustc
      rustfmt
      clippy
      rust-analyzer
      delve
      gdb
    ];
  };
}
