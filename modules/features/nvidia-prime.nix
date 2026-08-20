_: {
  flake.modules.nixos.nvidia-prime = _: {
    hardware.nvidia.prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
}
