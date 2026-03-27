{ config, ... }:
let
  flakeConfig = config;
in {
  flake.modules.nixos.system-packages = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      neovim
      wget
      curl
      git
    ];

    environment.variables.EDITOR = "nvim";
  };

  flake.modules.darwin.system-packages = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      neovim
      wget
      curl
      git
    ];

    environment.variables.EDITOR = "nvim";
  };

  flake.modules.combined.system-packages = { system, ... }: let
    isDarwin = builtins.match ".*-darwin" system != null;
  in {
    imports = [
      (if isDarwin
       then flakeConfig.flake.modules.darwin.system-packages
       else flakeConfig.flake.modules.nixos.system-packages)
    ];
  };
}
