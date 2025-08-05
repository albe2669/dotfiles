{...}: {
  imports = [
    ../../home/common.nix
    ../../home/fish
    ../../home/git
    ../../home/lazydocker
    ../../home/lazygit
    ../../home/yazi
    ../../home/nvim
    ../../home/fonts.nix

    ../../home/langs.nix
    ../../home/python3.nix

    ../../home/direnv.nix
    ../../home/tmux.nix
    ../../home/utils.nix
  ];

  programs.git.extraConfig.safe.directory = [
    "/mnt/c/Users/AlbertRiseNielsen/Coding/Man-in-the-Middle"
    "/mnt/c/Users/AlbertRiseNielsen/Coding/Man-in-the-Middle/*"
  ];
}
