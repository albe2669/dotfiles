{lib, ...}: {
  boot = {
    kernelParams = ["pcie_pm=off" "usbcore.autosuspend=-1" "pcie_aspm=off"];
    loader = {
      grub = {
        enable = lib.mkDefault true;
        useOSProber = true;
      };
    };
  };
}
