{pkgs, ...}: {
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      package = pkgs.direnv.overrideAttrs {doCheck = false;};
    };

    # fish = {
    #   shellInit = ''
    #     direnv hook fish | source
    #   '';
    # };
  };
}
