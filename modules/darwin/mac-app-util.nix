{inputs, ...}: let
  mac-app-util = inputs.mac-app-util;
in {
  imports = [
    mac-app-util.darwinModules.default
  ];

  hm.imports = [
    mac-app-util.homeManagerModules.default
  ];
}
