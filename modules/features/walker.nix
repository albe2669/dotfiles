{
  config,
  inputs,
  ...
}:
{
  flake.modules.homeManager.walker =
    { inputs, ... }:
    {
      imports = [
        inputs.walker.homeManagerModules.default
      ];

      programs.walker = {
        enable = true;
        runAsService = true;

        config = {
          force_keyboard_focus = false;
          close_when_open = true;
          click_to_close = true;
          selection_wrap = false;
          global_argument_delimiter = "#";
          exact_search_prefix = "'";
          theme = "default";
          disable_mouse = false;
          debug = false;
          page_jump_items = 10;
          hide_quick_activation = false;
          resume_last_query = false;

          shell = {
            anchor_top = true;
            anchor_bottom = true;
            anchor_left = true;
            anchor_right = true;
          };

          placeholders = {
            default = {
              input = "Search";
              list = "No Results";
            };
          };

          keybinds = {
            close = [ "Escape" ];
            next = [ "Down" ];
            previous = [ "Up" ];
            toggle_exact = [ "ctrl e" ];
            resume_last_query = [ "ctrl r" ];
            quick_activate = [
              "F1"
              "F2"
              "F3"
              "F4"
            ];
            page_down = [ "Page_Down" ];
            page_up = [ "Page_Up" ];
          };

          providers = {
            default = [
              "desktopapplications"
              "calc"
              "runner"
              "websearch"
            ];
            empty = [ "desktopapplications" ];
            ignore_preview = [ ];
            max_results = 50;

            argument_delimiter = {
              runner = " ";
            };

            sets = { };
            max_results_provider = { };

            prefixes = [
              {
                prefix = ";";
                provider = "providerlist";
              }
              {
                prefix = ">";
                provider = "runner";
              }
              {
                prefix = "/";
                provider = "files";
              }
              {
                prefix = ".";
                provider = "symbols";
              }
              {
                prefix = "!";
                provider = "todo";
              }
              {
                prefix = "%";
                provider = "bookmarks";
              }
              {
                prefix = "=";
                provider = "calc";
              }
              {
                prefix = "@";
                provider = "websearch";
              }
              {
                prefix = ":";
                provider = "clipboard";
              }
              {
                prefix = "#";
                provider = "windows";
              }
            ];

            clipboard = {
              time_format = "%d.%m. - %H:%M";
            };

            actions = {
              fallback = [
                {
                  action = "menus:open";
                  label = "open";
                  after = "Nothing";
                }
                {
                  action = "menus:default";
                  label = "run";
                  after = "Close";
                }
                {
                  action = "menus:parent";
                  label = "back";
                  bind = "Escape";
                  after = "Nothing";
                }
                {
                  action = "erase_history";
                  label = "clear hist";
                  bind = "ctrl h";
                  after = "AsyncReload";
                }
              ];

              dmenu = [
                {
                  action = "select";
                  default = true;
                  bind = "Return";
                }
              ];

              providerlist = [
                {
                  action = "activate";
                  default = true;
                  bind = "Return";
                  after = "ClearReload";
                }
              ];

              bluetooth = [
                {
                  action = "find";
                  bind = "ctrl f";
                  after = "AsyncClearReload";
                }
                {
                  action = "remove";
                  bind = "ctrl d";
                  after = "AsyncReload";
                }
                {
                  action = "trust";
                  bind = "ctrl t";
                  after = "AsyncReload";
                }
                {
                  action = "untrust";
                  bind = "ctrl t";
                  after = "AsyncReload";
                }
                {
                  action = "pair";
                  bind = "Return";
                  after = "AsyncReload";
                }
                {
                  action = "connect";
                  default = true;
                  bind = "Return";
                  after = "AsyncReload";
                }
                {
                  action = "disconnect";
                  default = true;
                  bind = "Return";
                  after = "AsyncReload";
                }
              ];

              calc = [
                {
                  action = "copy";
                  default = true;
                  bind = "Return";
                }
                {
                  action = "delete";
                  bind = "ctrl d";
                  after = "AsyncReload";
                }
                {
                  action = "save";
                  bind = "ctrl s";
                  after = "AsyncClearReload";
                }
              ];

              websearch = [
                {
                  action = "search";
                  default = true;
                  bind = "Return";
                }
              ];

              desktopapplications = [
                {
                  action = "start";
                  default = true;
                  bind = "Return";
                }
                {
                  action = "start:keep";
                  label = "open+next";
                  bind = "shift Return";
                  after = "KeepOpen";
                }
                {
                  action = "new_instance";
                  label = "new instance";
                  bind = "ctrl Return";
                }
                {
                  action = "new_instance:keep";
                  label = "new+next";
                  bind = "ctrl alt Return";
                  after = "KeepOpen";
                }
                {
                  action = "pin";
                  bind = "ctrl p";
                  after = "AsyncReload";
                }
                {
                  action = "unpin";
                  bind = "ctrl p";
                  after = "AsyncReload";
                }
                {
                  action = "pinup";
                  bind = "ctrl n";
                  after = "AsyncReload";
                }
                {
                  action = "pindown";
                  bind = "ctrl m";
                  after = "AsyncReload";
                }
              ];

              files = [
                {
                  action = "open";
                  default = true;
                  bind = "Return";
                }
                {
                  action = "opendir";
                  label = "open dir";
                  bind = "ctrl Return";
                }
                {
                  action = "copypath";
                  label = "copy path";
                  bind = "ctrl shift c";
                }
                {
                  action = "copyfile";
                  label = "copy file";
                  bind = "ctrl c";
                }
              ];

              "1password" = [
                {
                  action = "copy_password";
                  label = "copy password";
                  default = true;
                  bind = "Return";
                }
                {
                  action = "copy_username";
                  label = "copy username";
                  bind = "shift Return";
                }
                {
                  action = "copy_2fa";
                  label = "copy 2fa";
                  bind = "ctrl Return";
                }
              ];

              todo = [
                {
                  action = "save";
                  default = true;
                  bind = "Return";
                  after = "AsyncClearReload";
                }
                {
                  action = "save_next";
                  label = "save & new";
                  bind = "shift Return";
                  after = "AsyncClearReload";
                }
                {
                  action = "delete";
                  bind = "ctrl d";
                  after = "AsyncClearReload";
                }
                {
                  action = "active";
                  default = true;
                  bind = "Return";
                  after = "Nothing";
                }
                {
                  action = "inactive";
                  default = true;
                  bind = "Return";
                  after = "Nothing";
                }
                {
                  action = "done";
                  bind = "ctrl f";
                  after = "Nothing";
                }
                {
                  action = "change_category";
                  bind = "ctrl y";
                  label = "change category";
                  after = "Nothing";
                }
                {
                  action = "clear";
                  bind = "ctrl x";
                  after = "AsyncClearReload";
                }
                {
                  action = "create";
                  bind = "ctrl a";
                  after = "AsyncClearReload";
                }
                {
                  action = "search";
                  bind = "ctrl a";
                  after = "AsyncClearReload";
                }
              ];

              runner = [
                {
                  action = "run";
                  default = true;
                  bind = "Return";
                }
                {
                  action = "runterminal";
                  label = "run in terminal";
                  bind = "shift Return";
                }
              ];

              symbols = [
                {
                  action = "run_cmd";
                  label = "select";
                  default = true;
                  bind = "Return";
                }
              ];

              unicode = [
                {
                  action = "run_cmd";
                  label = "select";
                  default = true;
                  bind = "Return";
                }
              ];

              clipboard = [
                {
                  action = "copy";
                  default = true;
                  bind = "Return";
                }
                {
                  action = "remove";
                  bind = "ctrl d";
                  after = "AsyncClearReload";
                }
                {
                  action = "remove_all";
                  label = "clear";
                  bind = "ctrl shift d";
                  after = "AsyncClearReload";
                }
                {
                  action = "show_images_only";
                  label = "only images";
                  bind = "ctrl i";
                  after = "AsyncClearReload";
                }
                {
                  action = "show_text_only";
                  label = "only text";
                  bind = "ctrl i";
                  after = "AsyncClearReload";
                }
                {
                  action = "show_combined";
                  label = "show all";
                  bind = "ctrl i";
                  after = "AsyncClearReload";
                }
                {
                  action = "pause";
                  bind = "ctrl p";
                }
                {
                  action = "unpause";
                  bind = "ctrl p";
                }
                {
                  action = "edit";
                  bind = "ctrl o";
                }
              ];

              bookmarks = [
                {
                  action = "save";
                  bind = "Return";
                  after = "AsyncClearReload";
                }
                {
                  action = "open";
                  default = true;
                  bind = "Return";
                }
                {
                  action = "delete";
                  bind = "ctrl d";
                  after = "AsyncClearReload";
                }
                {
                  action = "change_category";
                  label = "Change category";
                  bind = "ctrl y";
                  after = "Nothing";
                }
                {
                  action = "change_browser";
                  label = "Change browser";
                  bind = "ctrl b";
                  after = "Nothing";
                }
                {
                  action = "import";
                  label = "Import";
                  bind = "ctrl i";
                  after = "AsyncClearReload";
                }
                {
                  action = "create";
                  bind = "ctrl a";
                  after = "AsyncClearReload";
                }
                {
                  action = "search";
                  bind = "ctrl a";
                  after = "AsyncClearReload";
                }
              ];
            };
          };
        };

        elephant = {
          installService = true;
          providers = [
            "desktopapplications"
            "files"
            "clipboard"
            "runner"
            "symbols"
            "calc"
            "menus"
            "providerlist"
            "websearch"
            "todo"
            "bookmarks"
            "unicode"
            "bluetooth"
            "windows"
            "snippets"
            "1password"
          ];
        };
      };
    };

  flake.modules.combined.walker =
    { ... }:
    {
      hm.imports = [ config.flake.modules.homeManager.walker ];
    };
}
