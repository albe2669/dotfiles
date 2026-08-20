_: {
  flake.modules.homeManager.azure-cli = {pkgs, ...}: {
    home.packages = with pkgs; [
      (azure-cli.withExtensions [])
      kubelogin
    ];
  };
}
