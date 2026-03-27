{ config, ... }: {
  flake.modules.homeManager.k8 = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
      kubectl
      kind
      kustomize
    ];
  };

  flake.modules.combined.k8 = { ... }: {
    hm.imports = [ config.flake.modules.homeManager.k8 ];
  };
}
