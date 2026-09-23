{
  lib,
  config,
  inputs,
  ...
}: let
  autoImport = import ../lib/auto-import.nix lib;
  helpers = import ../lib/helpers.nix;

  validCategories = [
    "Tools"
    "Software"
    "System software"
    "Programming languages"
  ];

  featureFiles = autoImport ../modules/features;
  rawFeatures = map (path: import path) featureFiles;

  resolve = value:
    if builtins.isFunction value
    then
      resolve (value {
        inherit config inputs;
      })
    else if builtins.isList value
    then value
    else [value];

  features = builtins.concatLists (map resolve rawFeatures);

  byKey = key:
    builtins.foldl' (acc: f:
      if f ? ${key}
      then acc // {${f.name} = f.${key};}
      else acc) {}
    features;

  featureNixos = byKey "nixos";
  featureDarwin = byKey "darwin";
  featureHomeManager = byKey "homeManager";

  autoCombined =
    builtins.foldl' (
      acc: f: let
        auto = {system, ...}: let
          isDarwin = helpers.isDarwin system;
          osMod =
            if isDarwin
            then f.darwin or null
            else f.nixos or null;
          hmMod = f.homeManager or null;
        in {
          imports = lib.optional (osMod != null) osMod;
          hm.imports = lib.optional (hmMod != null) hmMod;
        };
      in
        acc
        // {
          ${f.name} =
            if f ? combined
            then
              args: let
                autoResult = auto args;
                combinedResult = f.combined args;
              in
                {
                  imports = (autoResult.imports or []) ++ (combinedResult.imports or []);
                  hm.imports = (autoResult.hm.imports or []) ++ (combinedResult.hm.imports or []);
                }
                // (lib.removeAttrs combinedResult [
                  "imports"
                  "hm"
                ])
                // (lib.removeAttrs autoResult [
                  "imports"
                  "hm"
                ])
            else auto;
        }
    ) {}
    features;

  # Each feature declares its category. If software is provided, those
  # package names map to the feature's category. If software is omitted,
  # the feature name itself maps to the category. showInReadme = false
  # excludes the feature entirely from the category mapping.
  software =
    builtins.foldl' (
      acc: f:
        if f ? showInReadme && !f.showInReadme
        then acc
        else let
          pkgs = f.software or [f.name];
        in
          builtins.foldl' (s: pkg: s // {${pkg} = f.category;}) acc pkgs
    ) {}
    features;
in {
  options.flake.modules = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.deferredModule);
    default = {};
    description = "Dendritic modules organized by class (nixos, homeManager, darwin, combined)";
  };

  options.flake.software = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = {};
    description = "Package name to category mapping, derived from feature metadata";
  };

  config.flake.modules.nixos = featureNixos;
  config.flake.modules.darwin = featureDarwin;
  config.flake.modules.homeManager = featureHomeManager;
  config.flake.modules.combined = autoCombined;
  config.flake.software = software;

  imports =
    [
      ./home-manager-wiring.nix
    ]
    ++ (autoImport ./configurations);
}
