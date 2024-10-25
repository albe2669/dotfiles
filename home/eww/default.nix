{
  variables,
  lib,
  ...
}: let 
  colorScss = ''
    \$color: #f01;
  '';

  colorPath = variables.dotfilesLocation + (builtins.toPath "/home/eww/config/generated.scss");
in {
  home.activation = {
    createColors = lib.hm.dag.entryBefore ["writeBoundary"] ''
      cat <<EOF > ${colorPath}
      ${colorScss}
      EOF
    '';
  };

  programs.eww = {
    enable = true;
    configDir = ./config;
    # enableFishIntegration = true;
  };
}
