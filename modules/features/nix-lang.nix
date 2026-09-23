{
  category = "Programming languages";
  name = "nix-lang";
  software = [
    "nixd"
    "nil"
    "tree-sitter"
  ];

  homeManager = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
      nixd
      nil
      tree-sitter
    ];
  };
}
