{
  category = "Tools";
  name = "gcloud";
  software = ["google-cloud-sdk"];

  homeManager = {pkgs, ...}: let
    gdk = pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]);
  in {
    home.packages = [
      gdk
    ];
  };
}
