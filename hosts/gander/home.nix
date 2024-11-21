{...}: {
  nixpkgs.config.allowUnfree = true;
  imports = [
    ../../home/common.nix
    ../../home/dunst
    ../../home/fish
    ../../home/git
    ../../home/kitty
    ../../home/lazygit
    ../../home/nvim
    ../../home/yazi
    ../../home/zathura

    ../../home/k8.nix
    ../../home/langs.nix
    ../../home/python3.nix
    ../../home/tex.nix

    ../../home/anytype.nix
    ../../home/gcloud.nix
    ../../home/obs.nix
    ../../home/phpstorm.nix
    ../../home/php.nix
    ../../home/programs.nix
    ../../home/spacedrive.nix
    ../../home/utils.nix
    ../../home/vscode.nix
  ];
}
