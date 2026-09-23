{
  category = "System software";
  name = "pipewire";

  nixos = {pkgs-unstable, ...}: {
    services.pipewire = {
      enable = true;
      package = pkgs-unstable.pipewire;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      audio.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    security.rtkit.enable = true;

    hm.home.packages = with pkgs-unstable; [
      pwvucontrol
      easyeffects
    ];
  };
}
