{ pkgs-unstable, ...}: {
  # stylix.targets.zellij.enable = true;

  programs.zellij = {
    enable = true;
    package = pkgs-unstable.zellij;
    enableFishIntegration = true;
    settings = {
      theme = "everforest-dark";
    };
  };
}
