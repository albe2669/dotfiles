{
  pkgs,
  ...
}: {
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [
      # fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra

      # nerd fonts
      (nerdfonts.override {
        fonts = [
          "FiraCode"  
        ]
      })

      # icons
      material-design-icons
      font-awesome
    ];

    fontconfig.defaultFonts = {
      serif = ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      monospace = ["Fira Code Nerd Font"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
