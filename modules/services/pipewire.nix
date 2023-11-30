{pkgs-unstable, ...}: {
  services.pipewire = {
    enable = true;
    package = pkgs-unstable.pipewire;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  security.rtkit.enable = true;

  # Causes issues with pipewire if enabled
  sound.enable = false;
  hardware.pulseaudio.enable = false;
}
