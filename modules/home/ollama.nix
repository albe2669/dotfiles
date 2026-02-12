{
  pkgs-unstable,
  pkgs,
  ...
}: let
  packageSuffix =
    if pkgs.config.rocmSupport
    then "-rocm"
    else if pkgs.config.cuda
    then "-cuda"
    else "";
in {
  services.ollama = {
    enable = true;

    package = pkgs-unstable."ollama${packageSuffix}";
  };
}
