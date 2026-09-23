{
  category = "System software";
  name = "nvidia";

  nixos = {config, ...}: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;

      # Experimental: can cause sleep/suspend failures.
      powerManagement.enable = false;

      # Turing+ only; turns off GPU when idle.
      powerManagement.finegrained = false;

      # Turing+ open kernel module; alpha-quality, false recommended.
      open = false;

      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
