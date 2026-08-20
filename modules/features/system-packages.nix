_: let
  common = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      neovim
      wget
      curl
      git
    ];

    environment.variables.EDITOR = "nvim";
  };
in {
  flake.modules.nixos.system-packages = common;
  flake.modules.darwin.system-packages = common;
}
