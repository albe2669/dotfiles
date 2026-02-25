{pkgs-unstable, ...}: {
  home.packages = with pkgs-unstable; [
    (azure-cli.withExtensions [])
    kubelogin
  ];
}
