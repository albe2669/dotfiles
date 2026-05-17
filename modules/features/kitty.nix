{config, ...}: {
  flake.modules.homeManager.kitty = {
    config,
    lib,
    pkgs,
    ...
  }: {
    stylix.targets.kitty = {
      enable = true;
      colors.enable = true;
      fonts.enable = false;
      opacity.enable = true;
    };

    programs.kitty = {
      enable = true;

      font = {
        inherit (config.stylix.fonts.sansSerif) name package;
        size = config.stylix.fonts.sizes.terminal;
      };

      settings =
        {
          scrollback_lines = 5000;
          cursor_shape = "block";
        }
        // lib.optionalAttrs config.opts.variables.isDarwin {
          background_blur = 48;
          shell = "${pkgs.fish}/bin/fish";
        };

      # Map Cmd to act as Ctrl inside the terminal (macOS only)
      keybindings = lib.optionalAttrs config.opts.variables.isDarwin {
        "cmd+a" = "send_text all \\x01";
        "cmd+b" = "send_text all \\x02";
        "cmd+c" = "send_text all \\x03";
        "cmd+d" = "send_text all \\x04";
        "cmd+e" = "send_text all \\x05";
        "cmd+f" = "send_text all \\x06";
        "cmd+g" = "send_text all \\x07";
        "cmd+h" = "send_text all \\x08";
        "cmd+i" = "send_text all \\x09";
        "cmd+j" = "send_text all \\x0a";
        "cmd+k" = "send_text all \\x0b";
        "cmd+l" = "send_text all \\x0c";
        "cmd+n" = "send_text all \\x0e";
        "cmd+o" = "send_text all \\x0f";
        "cmd+p" = "send_text all \\x10";
        "cmd+r" = "send_text all \\x12";
        "cmd+s" = "send_text all \\x13";
        "cmd+t" = "send_text all \\x14";
        "cmd+u" = "send_text all \\x15";
        "cmd+v" = "send_text all \\x16";
        "cmd+w" = "send_text all \\x17";
        "cmd+x" = "send_text all \\x18";
        "cmd+y" = "send_text all \\x19";
        "cmd+z" = "send_text all \\x1a";
        "cmd+[" = "send_text all \\x1b"; # Ctrl+[ = Escape

        # Restore clipboard via Cmd+Shift
        "cmd+shift+c" = "copy_to_clipboard";
        "cmd+shift+v" = "paste_from_clipboard";
      };
    };
  };

  flake.modules.combined.kitty = {...}: {
    hm.imports = [config.flake.modules.homeManager.kitty];
  };
}
