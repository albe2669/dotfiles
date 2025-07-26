{ config, lib, ... }:

{
  options = {
    theme = {
      font = {
        family = lib.mkOption {
          type = lib.types.str;
          default = "Iosevka Nerd Font";
          description = "Font family name";
        };

        regularStyle = lib.mkOption {
          type = lib.types.str;
          default = "Regular";
          description = "Regular font style";
        };

        boldStyle = lib.mkOption {
          type = lib.types.str;
          default = "Bold";
          description = "Bold font style";
        };

        italicStyle = lib.mkOption {
          type = lib.types.str;
          default = "Italic";
          description = "Italic font style";
        };

        boldItalicStyle = lib.mkOption {
          type = lib.types.str;
          default = "Bold Italic";
          description = "Bold italic font style";
        };
      };

      colors = {
        bg_dim = lib.mkOption {
          type = lib.types.str;
          default = "#232A2E";
          description = "Dimmed background";
        };

        bg0 = lib.mkOption {
          type = lib.types.str;
          default = "#2D353B";
          description = "Default background";
        };

        bg1 = lib.mkOption {
          type = lib.types.str;
          default = "#343F44";
          description = "Cursor line background, lighter";
        };

        bg2 = lib.mkOption {
          type = lib.types.str;
          default = "#3D484D";
          description = "Cursor line background, lighter still";
        };

        bg3 = lib.mkOption {
          type = lib.types.str;
          default = "#475258";
          description = "Popup menu background, even lighter";
        };

        bg4 = lib.mkOption {
          type = lib.types.str;
          default = "#4F585E";
          description = "Window split seperator, lighter still";
        };

        bg5 = lib.mkOption {
          type = lib.types.str;
          default = "#56635f";
          description = "Lighter";
        };

        bg_visual = lib.mkOption {
          type = lib.types.str;
          default = "#543A48";
          description = "Visual selection";
        };

        bg_red = lib.mkOption {
          type = lib.types.str;
          default = "#514045";
          description = "Error";
        };

        bg_green = lib.mkOption {
          type = lib.types.str;
          default = "#425047";
          description = "Hints";
        };

        bg_blue = lib.mkOption {
          type = lib.types.str;
          default = "#3A515D";
          description = "Info";
        };

        bg_yellow = lib.mkOption {
          type = lib.types.str;
          default = "#4D4C43";
          description = "Warning";
        };

        fg = lib.mkOption {
          type = lib.types.str;
          default = "#D3C6AA";
          description = "Default foreground";
        };

        red = lib.mkOption {
          type = lib.types.str;
          default = "#E67E80";
          description = "Red color";
        };

        orange = lib.mkOption {
          type = lib.types.str;
          default = "#E69875";
          description = "Orange color";
        };

        yellow = lib.mkOption {
          type = lib.types.str;
          default = "#DBBC7F";
          description = "Yellow color";
        };

        green = lib.mkOption {
          type = lib.types.str;
          default = "#A7C080";
          description = "Green color";
        };

        aqua = lib.mkOption {
          type = lib.types.str;
          default = "#83C092";
          description = "Aqua color";
        };

        blue = lib.mkOption {
          type = lib.types.str;
          default = "#7FBBB3";
          description = "Blue color";
        };

        purple = lib.mkOption {
          type = lib.types.str;
          default = "#D699B6";
          description = "Purple color";
        };

        grey0 = lib.mkOption {
          type = lib.types.str;
          default = "#7A8478";
          description = "Grey color variant 0";
        };

        grey1 = lib.mkOption {
          type = lib.types.str;
          default = "#859289";
          description = "Grey color variant 1";
        };

        grey2 = lib.mkOption {
          type = lib.types.str;
          default = "#9DA9A0";
          description = "Grey color variant 2";
        };

        statusline1 = lib.mkOption {
          type = lib.types.str;
          default = "#A7C080";
          description = "Statusline color 1";
        };

        statusline2 = lib.mkOption {
          type = lib.types.str;
          default = "#D3C6AA";
          description = "Statusline color 2";
        };

        statusline3 = lib.mkOption {
          type = lib.types.str;
          default = "#E67E80";
          description = "Statusline color 3";
        };
      };
    };
  };
}
