{pkgs, ...}: {
  home.packages = with pkgs; [
    hyprsunset
  ];

  services.hyprsunset = {
    enable = true;
  };

  xdg.configFile."hypr/hyprsunset.conf" = {
    text = ''
      profile {
        time = 06:00
        identity = true
      }
      profile {
        time = 19:00
        temperature = 6500
      }
    '';
  };
}


