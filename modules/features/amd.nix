# SOURCE: https://nixos.wiki/wiki/Nvidia
{config, ...}: {
  flake.modules.nixos.amd = _: {
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Load amd driver for Xorg and Wayland
    services.xserver.videoDrivers = ["amdgpu"];
  };

  flake.modules.combined.amd = {...}: {
    imports = [config.flake.modules.nixos.amd];
  };
}
