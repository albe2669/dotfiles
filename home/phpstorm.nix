{pkgs, ...}: {
  home.packages = with pkgs; [
    jetbrains.phpstorm
  ];
}
