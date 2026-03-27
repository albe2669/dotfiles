{config, ...}: {
  flake.modules.homeManager.gcloud = {pkgs, ...}: let
    gdk = pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]);
  in {
    home.packages = [
      gdk
    ];
  };

  flake.modules.combined.gcloud = {...}: {
    hm.imports = [config.flake.modules.homeManager.gcloud];
  };
}
