{
  category = "System software";
  name = "wireless";

  nixos = _: {
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
}
