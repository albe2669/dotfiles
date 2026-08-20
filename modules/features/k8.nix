_: {
  flake.modules.homeManager.k8 = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
      kubectl
      kind
      kustomize
    ];
  };
}
