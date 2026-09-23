{
  category = "System software";
  name = "system-packages";
  software = [
    "neovim"
    "wget"
    "curl"
    "git"
  ];

  nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      neovim
      wget
      curl
      git
    ];

    environment.variables.EDITOR = "nvim";
  };

  darwin = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      neovim
      wget
      curl
      git
    ];

    environment.variables.EDITOR = "nvim";
  };
}
