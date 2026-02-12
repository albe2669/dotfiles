# SOURCE: https://nixos.wiki/wiki/Nvidia
{...}: {
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load amd driver for Xorg and Wayland
  services.xserver.videoDrivers = ["amd"];

  nixpkgs.config.rocmSupport = true;
}
