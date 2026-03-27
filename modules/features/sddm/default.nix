{config, ...}: {
  flake.modules.nixos.sddm = {...}: {
    imports = [
      ./theme.nix
    ];

    services = {
      xserver = {
        enable = true;
        displayManager.lightdm.enable = false;
      };

      displayManager = {
        gdm.enable = false;
        sddm = {
          enable = true;
          wayland = {
            enable = false;
          };
        };
      };
    };
  };

  flake.modules.combined.sddm = {...}: {
    imports = [config.flake.modules.nixos.sddm];
  };
}
