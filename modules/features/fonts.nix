{config, ...}: let
  fontPackages = {pkgs}: {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      nerd-fonts.fira-code
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
      nerd-fonts.jetbrains-mono

      material-design-icons
      font-awesome
    ];

    defaultFonts = {
      serif = ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      monospace = ["Iosevka Nerd Font Mono"];
      emoji = ["Noto Color Emoji"];
    };
  };
in {
  flake.modules.nixos.fonts = {pkgs, ...}: let
    fontConfig = fontPackages {inherit pkgs;};
  in {
    fonts = {
      enableDefaultPackages = true;
      fontDir.enable = true;

      packages = fontConfig.packages;
      fontconfig.defaultFonts = fontConfig.defaultFonts;
    };
  };

  flake.modules.homeManager.fonts = {pkgs, ...}: let
    fontConfig = fontPackages {inherit pkgs;};
  in {
    home.packages = fontConfig.packages;

    stylix.targets.fontconfig.enable = true;

    fonts.fontconfig = {
      enable = true;
      defaultFonts = fontConfig.defaultFonts;
    };
  };

  flake.modules.combined.fonts = {...}: {
    imports = [config.flake.modules.nixos.fonts];
    hm.imports = [config.flake.modules.homeManager.fonts];
  };
}
