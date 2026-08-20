{
  lib,
  config,
  ...
}: let
  autoImport = import ../lib/auto-import.nix lib;
  helpers = import ../lib/helpers.nix;

  # Directory names are a baseline; features that register modules under
  # different names (e.g. ai-shared -> ai) keep their own combined blocks.
  featureDir = ../modules/features;
  dirFeatureNames = let
    entries = builtins.readDir featureDir;
    nixFiles = builtins.filter (
      name:
        entries.${name}
        == "regular"
        && lib.hasSuffix ".nix" name
        && name != "default.nix"
        && !lib.hasPrefix "_" name
    ) (builtins.attrNames entries);
    subDirs = builtins.filter (
      name:
        entries.${name}
        == "directory"
        && !lib.hasPrefix "_" name
        && builtins.pathExists (featureDir + "/${name}/default.nix")
    ) (builtins.attrNames entries);
    stripExt = name: builtins.head (builtins.split "\\." name);
  in
    map stripExt nixFiles ++ subDirs;
in {
  options.flake.modules = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.deferredModule);
    default = {};
    description = "Dendritic modules organized by class (nixos, homeManager, darwin, combined)";
  };

  # Module references are captured in the flake-parts scope and baked into
  # the deferredModule closure — the same technique the original
  # pass-throughs used.
  config.flake.modules.combined = lib.genAttrs dirFeatureNames (
    name: let
      hmMod = config.flake.modules.homeManager.${name} or null;
      nixosMod = config.flake.modules.nixos.${name} or null;
      darwinMod = config.flake.modules.darwin.${name} or null;
    in
      {system, ...}: let
        isDarwin = helpers.isDarwin system;
        osMod =
          if isDarwin
          then darwinMod
          else nixosMod;
      in {
        imports = lib.optional (osMod != null) osMod;
        hm.imports = lib.optional (hmMod != null) hmMod;
      }
  );

  imports =
    [
      ./home-manager-wiring.nix
    ]
    ++ (autoImport ./features)
    ++ (autoImport ./configurations);
}
