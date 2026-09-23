{
  category = "System software";
  name = "nvidia-prime";

  nixos = _: {
    hardware.nvidia.prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
}
