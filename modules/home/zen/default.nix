{
  inputs,
  system,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.lib.stylix) colors;
  firefox-addons = (pkgs.extend inputs.firefox-addons.overlays.default).firefox-addons;

  mkLockedAttrs = builtins.mapAttrs (
    _: value: {
      Value = value;
      Status = "locked";
    }
  );

  profileName = "bkxkrjhl.Default (release)";
in {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;
    package = lib.mkForce (
      config.lib.nixGL.wrapOffload inputs.zen-browser.packages."${system}".default
    );

    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      Preferences = mkLockedAttrs {
        "browser.search.suggest.enabled" = true;
        "browser.tabs.closeWindowWithLastTab" = false;
        "zen.view.compact.should-enable-at-startup" = true;
        "zen.view.use-single-toolbar" = false;
        "zen.view.welcome-screen.seen" = true;
      };
    };

    profiles."${profileName}" = {
      extensions.packages = with firefox-addons; [
        dashlane
        onepassword-password-manager
        ublock-origin
        refined-github
        darkreader
        vimium
      ];

      settings = {
        zen = {
          mods.updated-value-observer = true;
          swipe.is-fast-swipe = false;

          view = {
            compact.enable-at-startup = true;
            use-single-toolbar = false;
            window.scheme = 0;
          };

          welcome-screen.seen = true;
        };

        browser = {
          contentblocking.category = "custom";
          ml.enable = true;
          newtabpage.activity-stream.system.showWeatherOptIn = false;
          preferences.experimental.hidden = true;
          theme.toolbar-theme = 0;
          urlbar.suggest.quicksuggest.all = true;

          tabs.closeWindowWithLastTab = false;
          search.suggest.enabled = true;
        };

        privacy = {
          clearOnShutdown_v2.formdata = true;
          globalprivacycontrol.was_ever_enabled = true;
        };

        network = {
          dns.disablePrefetch = true;
          http.speculative-parallel-limit = 0;
          prefetch-next = false;
        };

        accessibility.typeaheadfind.flashBar = 0;

        dom.forms.autocomplete.formautofill = true;
        findbar.highlightAll = true;

        pdfjs = {
          enableAltTextForEnglish = true;
          enabledCache.state = true;
        };

        "print_printer" = "Mozilla Save to PDF";

        sidebar.visibility = "hide-sidebar";

        toolkit.legacyUserProfileCustomizations.stylesheets = {
          Value = true;
          Status = "locked";
        };
      };

      userChrome = import ./userChrome.nix {inherit colors;};
      # userContent = import ./userContent.nix {inherit colors;};
      containersForce = true;
      containers = {
        Personal = {
          color = "blue";
          icon = "fingerprint";
          id = 1;
        };
        Work = {
          color = "orange";
          icon = "briefcase";
          id = 2;
        };
        Alt = {
          color = "red";
          icon = "dollar";
          id = 3;
        };
      };
      keyboardShortcutsVersion = 17;
      keyboardShortcuts = [
        # Sidebar
        {
          id = "toggleSidebarKb";
          key = "z";
          modifiers = {control = true;};
        }
        {
          id = "viewGenaiChatSidebarKb";
          key = "x";
          modifiers = {control = true;};
        }

        # Compact mode
        {
          id = "zen-compact-mode-toggle";
          key = "s";
          modifiers = {accel = true;};
        }
        {
          id = "zen-compact-mode-show-sidebar";
          key = "s";
          modifiers = {
            alt = true;
            accel = true;
          };
        }

        # Workspace switching
        {
          id = "zen-workspace-switch-1";
          key = "1";
          modifiers = {control = true;};
        }
        {
          id = "zen-workspace-switch-2";
          key = "2";
          modifiers = {control = true;};
        }
        {
          id = "zen-workspace-switch-3";
          key = "3";
          modifiers = {control = true;};
        }
        {
          id = "zen-workspace-switch-4";
          key = "4";
          modifiers = {control = true;};
        }
        {
          id = "zen-workspace-switch-5";
          key = "5";
          modifiers = {control = true;};
        }
        {
          id = "zen-workspace-switch-6";
          key = "6";
          modifiers = {control = true;};
        }
        {
          id = "zen-workspace-switch-7";
          key = "7";
          modifiers = {control = true;};
        }
        {
          id = "zen-workspace-switch-8";
          key = "8";
          modifiers = {control = true;};
        }
        {
          id = "zen-workspace-switch-9";
          key = "9";
          modifiers = {control = true;};
        }
        {
          id = "zen-workspace-switch-10";
          key = "0";
          modifiers = {control = true;};
        }
        {
          id = "zen-workspace-forward";
          keycode = "VK_RIGHT";
          modifiers = {
            alt = true;
            accel = true;
          };
        }
        {
          id = "zen-workspace-backward";
          keycode = "VK_LEFT";
          modifiers = {
            alt = true;
            accel = true;
          };
        }

        # Split view
        {
          id = "zen-split-view-grid";
          key = "g";
          modifiers = {
            alt = true;
            accel = true;
          };
        }
        {
          id = "zen-split-view-vertical";
          key = "v";
          modifiers = {
            alt = true;
            accel = true;
          };
        }
        {
          id = "zen-split-view-horizontal";
          key = "h";
          modifiers = {
            alt = true;
            accel = true;
          };
        }
        {
          id = "zen-split-view-unsplit";
          key = "u";
          modifiers = {
            alt = true;
            accel = true;
          };
        }
        {
          id = "zen-new-empty-split-view";
          key = "*";
          modifiers = {
            shift = true;
            accel = true;
          };
        }

        # Tab management
        {
          id = "zen-toggle-pin-tab";
          key = "d";
          modifiers = {
            shift = true;
            accel = true;
          };
        }
        {
          id = "zen-close-all-unpinned-tabs";
          key = "k";
          modifiers = {
            shift = true;
            accel = true;
          };
        }
        {
          id = "zen-glance-expand";
          key = "o";
          modifiers = {accel = true;};
        }
        {
          id = "key_toggleMute";
          key = "m";
          modifiers = {control = true;};
        }

        # URL copy
        {
          id = "zen-copy-url";
          key = "c";
          modifiers = {
            shift = true;
            accel = true;
          };
        }
        {
          id = "zen-copy-url-markdown";
          key = "c";
          modifiers = {
            alt = true;
            shift = true;
            accel = true;
          };
        }

        # Window
        {
          id = "zen-new-unsynced-window";
          key = "n";
          modifiers = {
            shift = true;
            accel = true;
          };
        }

        # Disabled
        {
          id = "key_toggleReaderMode";
          disabled = true;
        }
        {
          id = "key_exitFullScreen";
          disabled = true;
        }
        {
          id = "key_exitFullScreen_old";
          disabled = true;
        }
        {
          id = "key_exitFullScreen_compat";
          disabled = true;
        }
      ];

      pinsForce = true;
      pins = let
        workspaceId = config.programs.zen-browser.profiles."${profileName}".spaces."Work".id;
        workContainerId = config.programs.zen-browser.profiles."${profileName}".containers."Work".id;
        mkWorkPin = id: url: title: pos: {
          inherit id url title;
          workspace = workspaceId;
          container = workContainerId;
          position = pos;
          isEssential = true;
          editedTitle = true;
        };
      in {
        "Gmail" =
          mkWorkPin "c802ade4-2ae1-4231-b86d-564706855a18"
          "https://mail.google.com/mail/u/0/#inbox" "Inbox"
          100;
        "Calendar" =
          mkWorkPin "3a37bdb6-166a-427a-af2d-104bdc480e0d"
          "https://calendar.google.com/calendar/u/0r" "Corti - Calendar"
          200;
        "Drive" =
          mkWorkPin "f7c53ed5-446a-421d-b88a-8116d9439c96"
          "https://drive.google.com/drive/home" "Google Drive"
          300;
        "Linear" =
          mkWorkPin "ce58e497-05a3-437b-8973-ae6865f3284e"
          "https://linear.app/corti/team/AGENT/active" "Linear"
          400;
        "Azure" =
          mkWorkPin "414b03a4-aee3-41b3-95b6-377ed7e3d6bd"
          "https://portal.azure.com/#home" "Azure"
          500;
        "Navan" =
          mkWorkPin "9defc09b-ac85-4b10-ab52-a411314a7020"
          "https://app.navan.com" "Navan"
          600;
        "Notion" =
          mkWorkPin "608dad79-ec7f-4b32-b37b-897036d947c2"
          "https://www.notion.so/cortihome" "Notion"
          700;
        "Datadog" =
          mkWorkPin "d2259d52-c0af-4dea-8582-0ff724ccb2f2"
          "https://app.datadoghq.eu/apm/home?graphType=flamegraph&personalized=false&shouldShowLegend=true&traceQuery=" "Datadog APM"
          800;
        "Claude" =
          mkWorkPin "d8f99b35-175d-4123-bbc1-56b77eb9e4d5"
          "https://claude.ai/new" "Claude"
          900;
        "Orca" =
          mkWorkPin "a22d9538-a7e1-4322-9d59-c24eb2a9afcc"
          "https://orca.corti.app/app/releases" "Orca Releases"
          1000;
        "GitHubStatus" =
          mkWorkPin "3bbb10c6-39e4-476e-b057-253f49242bac"
          "https://mrshu.github.io/github-statuses/" "GitHub Status"
          1100;
      };

      spacesForce = true;
      spaces = let
        containers = config.programs.zen-browser.profiles."${profileName}".containers;
      in {
        "Personal" = {
          id = "1c126ea4-93cc-406b-b724-de6274eefc48";
          position = 1000;
          icon = "☀️";
          container = containers."Personal".id;
        };
        "Work" = {
          id = "73eca14a-5498-406d-845f-55439aa80f90";
          position = 2000;
          icon = "🏛️";
          container = containers."Work".id;
        };
        "Alt" = {
          id = "a781d4e4-b7f6-4b9b-9324-b99d95c2f5f9";
          position = 3000;
          icon = "👁️‍🗨️";
          container = containers."Alt".id;
        };
      };
    };
  };
}
