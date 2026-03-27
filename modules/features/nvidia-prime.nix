{ config, ... }: {
  flake.modules.nixos.nvidia-prime = { ... }: {
    hardware.nvidia.prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  flake.modules.combined.nvidia-prime = { ... }: {
    imports = [ config.flake.modules.nixos.nvidia-prime ];
  };
}
