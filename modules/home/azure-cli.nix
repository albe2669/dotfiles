{pkgs-unstable, ...}: {
  home.packages = with pkgs-unstable; [
    (azure-cli.withExtensions [azure-cli.extensions.azure-devops])
  ];
}
