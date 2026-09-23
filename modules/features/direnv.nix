{
  category = "Tools";
  name = "direnv";

  homeManager = {pkgs, ...}: {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        package = pkgs.direnv.overrideAttrs {doCheck = false;};
      };
    };
  };
}
