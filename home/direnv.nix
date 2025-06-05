{...}: {
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # fish = {
    #   shellInit = ''
    #     direnv hook fish | source
    #   '';
    # };
  };
}
