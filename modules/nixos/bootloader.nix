{lib, ...}: {
  boot = {
    loader = {
      grub = {
        enable = lib.mkDefault true;
        useOSProber = true;
      };
    };
  };
}
