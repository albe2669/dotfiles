{
  variables,
  theme,
  lib,
  ...
}: let 
  colorScss = builtins.toString (builtins.attrValues (builtins.mapAttrs (name: color: "\\\$${name}: ${color};\n") theme.colors));

  fontScss = builtins.toString (builtins.attrValues (builtins.mapAttrs (name: font: "\\\$font_${name}: \"${font}\";\n") theme.font));

  generatedFile = variables.dotfilesLocation + (builtins.toPath "/home/eww/config/generated.scss");
in {
  home.activation = {
    createColors = lib.hm.dag.entryBefore ["writeBoundary"] ''
      cat <<EOF > ${generatedFile}
      ${colorScss}

      ${fontScss}
      EOF
    '';
  };

  programs.eww = {
    enable = true;
    configDir = ./config;
    # enableFishIntegration = true;
  };
}
