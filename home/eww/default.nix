{
  variables,
  theme,
  lib,
  ...
}: let 
  colorScss = builtins.toString (builtins.attrValues (builtins.mapAttrs (name: color: "\\\$${name}: ${color};\n") theme.colors));

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
