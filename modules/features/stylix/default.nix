{
  inputs,
  config,
  ...
}: let
  flakeConfig = config;
in {
  flake.modules.nixos.stylix = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];

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

  flake.modules.darwin.stylix = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      inputs.stylix.darwinModules.stylix
    ];

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

  flake.modules.combined.stylix = {system, ...}: let
    isDarwin = builtins.match ".*-darwin" system != null;
  in {
    imports = [
      (if isDarwin
      then flakeConfig.flake.modules.darwin.stylix
      else flakeConfig.flake.modules.nixos.stylix)
    ];
  };
}
