{ username, ... }:

{
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;
  
  imports = [
		../../home/alacritty
    ../../home/i3
  ];
}