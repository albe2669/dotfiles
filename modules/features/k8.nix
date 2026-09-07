_: {
  flake.modules.homeManager.k8 = {
    pkgs-unstable,
    inputs,
    system,
    ...
  }: {
    home.packages = with pkgs-unstable; [
      kubectl
      kind
      kustomize
      inputs.sofka.packages.${system}.sofka
    ];
  };
}
