{config, ...}: {
  flake.modules.nixos.wireless = _: {
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
