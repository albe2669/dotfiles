{
  variables,
  theme,
  nixpkgs-unstable,
  nixos-hardware,
  zen-browser,
}: let
  x64System = "x86_64-linux";
in {
  x64System = x64System;
  x64SpecialArgs = {
    inherit variables theme nixos-hardware zen-browser;

    system = x64System;

    username = variables.username;

    pkgs-unstable = import nixpkgs-unstable {
      system = x64System;

      # Necessary for installing paid or non-free software
      config.allowUnfree = true;

      config.permittedInsecurePackages = [
        "electron-29.4.6"
      ];

      # Overlays are only applied to the unstable channel, since they probably are
      overlays = [];
    };
  };
}
