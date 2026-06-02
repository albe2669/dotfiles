{pkgs, ...}: {
  home.packages = with pkgs; [
    (azure-cli.withExtensions [])
    kubelogin
  ];
}
