{
  variables,
  theme,
  lib,
  pkgs-unstable,
  config,
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


  home.packages = with pkgs-unstable; [
    (pkgs-unstable.callPackage ../../pkgs/yuckls {})
    eww
  ];

  xdg.configFile.eww = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/eww/config");
  };

}
