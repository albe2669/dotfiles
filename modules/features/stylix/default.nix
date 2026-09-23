{
  category = "System software";
  name = "stylix";

  nixos = {
    config,
    pkgs,
    inputs,
    ...
  }: {
    imports = [inputs.stylix.nixosModules.stylix];

    stylix = {
      enable = true;
      autoEnable = false;

      base16Scheme = ./everforest-dark-hard.yaml;
      polarity = "dark";

      image = ../wallpapers/images/misty_forest.jpg;

      opacity = {
        terminal = 0.85;
        popups = 0.8;
      };

      fonts = {
        sizes = {
          terminal = 11;
        };

        sansSerif = {
          package = pkgs.nerd-fonts.iosevka;
          name = "Iosevka Nerd Font";
        };
        monospace = {
          package = pkgs.nerd-fonts.iosevka;
          name = "Iosevka Nerd Font Mono";
        };
        serif = config.stylix.fonts.monospace;
      };
    };
  };

  darwin = {
    config,
    pkgs,
    inputs,
    ...
  }: {
    imports = [inputs.stylix.darwinModules.stylix];

    stylix = {
      enable = true;
      autoEnable = false;

      base16Scheme = ./everforest-dark-hard.yaml;
      polarity = "dark";

      image = ../wallpapers/images/misty_forest.jpg;

      opacity = {
        terminal = 0.85;
        popups = 0.8;
      };

      fonts = {
        sizes = {
          terminal = 11;
        };

        sansSerif = {
          package = pkgs.nerd-fonts.iosevka;
          name = "Iosevka Nerd Font";
        };
        monospace = {
          package = pkgs.nerd-fonts.iosevka;
          name = "Iosevka Nerd Font Mono";
        };
        serif = config.stylix.fonts.monospace;
      };
    };
  };
}
