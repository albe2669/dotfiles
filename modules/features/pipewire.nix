{config, ...}: {
  flake.modules.nixos.pipewire = {pkgs-unstable, ...}: {
    services.pipewire = {
      enable = true;
      package = pkgs-unstable.pipewire;
      alsa = {
        enable = true;
        support32Bit = true; # Enable 32-bit support for PipeWire ALSA
      };
      audio.enable = true;
      pulse.enable = true;
      # jack.enable = false;
      wireplumber.enable = true;
    };

    security.rtkit.enable = true;

    hm.home.packages = with pkgs-unstable; [
      pwvucontrol
      easyeffects
    ];
  };

  flake.modules.combined.pipewire = {...}: {
    imports = [config.flake.modules.nixos.pipewire];
  };
}
