{inputs, ...}: {
  category = "System software";
  name = "mac-app-util";

  darwin = _: let
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
