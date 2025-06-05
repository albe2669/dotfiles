{ inputs, ... }:
{
  nixGL.packages = inputs.nixgl.packages;
  nixGL.defaultWrapper = "nvidia";
  nixGL.offloadWrapper = "nvidiaPrime";
  nixGL.installScripts = [ "mesa" "nvidiaPrime" ];
}
