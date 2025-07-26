# Naming this file was one of the hardest things to do apparently. Both config, options, setting and args were already taken.
# So yes, it's a stupid name, but i can't be arsed anymore
{ lib, config, ... }:
with lib;
let 
  cfg = config.variables;
in {
  options = {
    variables = {
    username = mkOption {
      type = types.str;
      default = "goose";
      description = "System username";
    };

    isHidpi = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable HiDPI configuration";
    };

    homeDirectory = {
      path = mkOption {
        type = types.path;
        description = "Home directory path";
      };

      directories = mkOption {
        type = types.listOf types.str;
        default = ["Documents" "Downloads" "Music" "Pictures" "Pictures/FScreenshots" "Videos"];
        description = "Directories to create in home directory";
      };
    };

    git = {
      username = mkOption {
        type = types.str;
        default = "albe2669";
        description = "Git username";
      };

      email = mkOption {
        type = types.str;
        default = "albert@risenielsen.dk";
        description = "Git email";
      };
    };

    dotfilesLocation = mkOption {
      type = types.path;
      description = "Location of dotfiles";
    };

    initialPassword = mkOption {
      type = types.str;
      default = "changeme";
      description = "Initial user password";
    };

    screen = {
      scaleFactor = mkOption {
        type = types.int;
        description = "Screen scale factor";
      };

      dpi = mkOption {
        type = types.int;
        description = "Screen DPI";
      };
    };

    stateVersion = mkOption {
      type = types.str;
      default = "24.05";
      description = "NixOS state version";
    };
  };
  };

  config = {
    # Set computed values based on other options
    variables.homeDirectory.path = builtins.toPath "/home/${cfg.username}";
    variables.dotfilesLocation = cfg.homeDirectory.path + (builtins.toPath "/Documents/Coding/Other/dotfiles");
    variables.screen.scaleFactor = if cfg.isHidpi then 2 else 1;
    variables.screen.dpi = if cfg.isHidpi then 180 else 96;
  };
}
