{inputs, ...}: {
  category = "Tools";
  name = "k8";
  software = ["kubectl" "kind" "kustomize" "sofka"];

  homeManager = {
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
