{pkgs}: {
  packages = with pkgs; [
    # fonts
    noto-fonts # Now includes noto-fonts-extra
    noto-fonts-cjk-sans
    noto-fonts-color-emoji # Renamed from noto-fonts-emoji

    # nerd fonts
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.jetbrains-mono

    # icons
    material-design-icons
    font-awesome
  ];

  defaultFonts = {
    serif = ["Noto Serif"];
    sansSerif = ["Noto Sans"];
    monospace = ["Iosevka Nerd Font Mono"];
    emoji = ["Noto Color Emoji"];
  };
}
