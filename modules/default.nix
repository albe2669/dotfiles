{lib, ...}: let
  autoImport = import ../lib/auto-import.nix lib;
in {
  options.flake.modules = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.deferredModule);
    default = {};
    description = "Dendritic modules organized by class (nixos, homeManager, darwin, combined)";
  };

  imports =
    [
      ./home-manager-wiring.nix
    ]
    ++ (autoImport ./features)
    ++ (autoImport ./configurations);
}
