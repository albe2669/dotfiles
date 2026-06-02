{
  config,
  pkgs,
  ...
}: {
  stylix = {
    enable = true;
    autoEnable = false;

    # base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
    base16Scheme = ./everforest-dark-hard.yaml;
    polarity = "dark";

    image = ../../home/wallpapers/images/misty_forest.jpg;

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
}
