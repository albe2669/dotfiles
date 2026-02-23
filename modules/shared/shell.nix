{config, pkgs, ...}: with config.opts; let
  username = variables.username;
in {
  programs = {
    fish.enable = true;
  };

  environment.shells = with pkgs; [
    bash
    fish
  ];

  users.users."${username}".shell = pkgs.fish;
}
