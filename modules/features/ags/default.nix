{
  config,
  inputs,
  ...
}: {
  flake.modules.homeManager.ags = {
    config,
    inputs,
    system,
    lib,
    ...
  }:
    with config.opts; let
      colorScss = builtins.toString (builtins.attrValues (builtins.mapAttrs (name: color: "\\\$${name}: ${color};\n") theme.colors));

      fontScss = builtins.toString (builtins.attrValues (builtins.mapAttrs (name: font: "\\\$font_${name}: \"${font}\";\n") theme.font));

      generatedFile = variables.dotfilesLocation + (builtins.toPath "/modules/features/ags/config/generated.scss");
    in {
      imports = [
        inputs.ags.homeManagerModules.default
      ];

      home.activation = {
        createAgsColors = lib.hm.dag.entryBefore ["writeBoundary"] ''
          cat <<EOF > ${generatedFile}
          ${colorScss}

          ${fontScss}
          EOF
        '';
      };

      programs.ags = {
        enable = true;

        configDir = ./config;

        extraPackages = [
          inputs.astal.packages.${system}.battery
        ];
      };

      home.packages = [
        inputs.astal.packages.${system}.io
        inputs.astal.packages.${system}.notifd
      ];
    };

  flake.modules.combined.ags = {...}: {
    hm.imports = [config.flake.modules.homeManager.ags];
  };
}
