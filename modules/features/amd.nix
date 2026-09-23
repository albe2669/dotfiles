{
  category = "System software";
  name = "amd";

  nixos = _: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = ["amdgpu"];
  };
}
