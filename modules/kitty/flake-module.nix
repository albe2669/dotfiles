{ pkgs, lib, ... }:

{
  # Must be installed manually
  xdg.configFile.kitty = {
    source = ./config;
    recursive = true;
  };
}
