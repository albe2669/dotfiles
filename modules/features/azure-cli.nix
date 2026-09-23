{
  category = "Tools";
  name = "azure-cli";
  software = ["azure-cli" "kubelogin"];

  homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      (azure-cli.withExtensions [])
      kubelogin
    ];
  };
}
