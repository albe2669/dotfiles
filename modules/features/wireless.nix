{config, ...}: {
  flake.modules.nixos.wireless = {...}: {
    networking = {
      wireless.iwd = {
        enable = true;
        settings = {
          IPv6 = {
            Enabled = false;
          };
        };
      };

      networkmanager = {
        wifi = {
          backend = "iwd";
        };
      };
    };
  };

  flake.modules.combined.wireless = {...}: {
    imports = [config.flake.modules.nixos.wireless];
  };
}
