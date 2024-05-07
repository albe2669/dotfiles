{pkgs-unstable, ...}: {
  home.packages = with pkgs-unstable; [
    kubectl
    kind
    kustomize
  ];
}
