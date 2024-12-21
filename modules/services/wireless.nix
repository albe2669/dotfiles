{...}: {
  networking = {
    wireless.iwd = {
      enable = true;
      settings = {
        IPv6 = {
          Enabled = true;
        };
      };
    };

    networkmanager = {
      wifi = {
        backend = "iwd";
      };
    };
  };
}
