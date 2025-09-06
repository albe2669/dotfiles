{pkgs}: {
  packages = with pkgs; [
    # fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    noto-fonts-extra

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
