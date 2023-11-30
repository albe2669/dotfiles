{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    neovim
    wget
    curl
    git
  ];

  # TODO: Possibly setup fhs
  environment.variables.EDITOR = "nvim";
}
