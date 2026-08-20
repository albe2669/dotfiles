{inputs, ...}: {
  flake.modules.darwin.mac-app-util = _: let
    inherit (inputs) mac-app-util;
  in {
    imports = [
      mac-app-util.darwinModules.default
    ];

    hm.imports = [
      mac-app-util.homeManagerModules.default
    ];
  };
}
