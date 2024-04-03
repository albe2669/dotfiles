{...}: {
  imports = [
    ../../modules/core-server.nix
  ];

  environment.etc."dotfiles" = {
    source = ../..; 
  };
}
