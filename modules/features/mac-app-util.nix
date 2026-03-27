{ config, inputs, ... }: {
  flake.modules.darwin.mac-app-util = { ... }: let
    mac-app-util = inputs.mac-app-util;
  in {
    imports = [
      mac-app-util.darwinModules.default
    ];

    hm.imports = [
      mac-app-util.homeManagerModules.default
    ];
  };

  flake.modules.combined.mac-app-util = { ... }: {
    imports = [ config.flake.modules.darwin.mac-app-util ];
  };
}
