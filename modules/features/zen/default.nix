_: {
  flake.modules.homeManager.zen = {
    inputs,
    system,
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config.lib.stylix) colors;
    inherit ((pkgs.extend inputs.firefox-addons.overlays.default)) firefox-addons;

    mkLockedAttrs = builtins.mapAttrs (
      _: value: {
        Value = value;
        Status = "locked";
      }
    );

    profileName = "bkxkrjhl.Default (release)";

    # Parse a stylix hex color (without #) to an RGB integer set for Zen space themes.
    hexToRgb = hex: let
      digits = {
        "0" = 0;
        "1" = 1;
        "2" = 2;
        "3" = 3;
        "4" = 4;
        "5" = 5;
        "6" = 6;
        "7" = 7;
        "8" = 8;
        "9" = 9;
        "a" = 10;
        "b" = 11;
        "c" = 12;
        "d" = 13;
        "e" = 14;
        "f" = 15;
      };
      hexPair = pair: digits.${builtins.substring 0 1 pair} * 16 + digits.${builtins.substring 1 1 pair};
    in {
      red = hexPair (builtins.substring 0 2 hex);
      green = hexPair (builtins.substring 2 2 hex);
      blue = hexPair (builtins.substring 4 2 hex);
    };
  in {
    imports = [
      inputs.zen-browser.homeModules.twilight
    ];

    programs.zen-browser =
      {
        enable = true;
        # On Linux the flake's packages.${system}.default is already wrapFirefox-wrapped,
        # so nixGL.wrapOffload can layer on top and home-manager's mkFirefoxModule can
        # still .override { cfg = ... } it. On Darwin "signed" mode installs the upstream
        # .app untouched, thereby preserving its code signature so TCC permissions (screen
        # sharing, camera, etc.) persist across rebuilds. "wrapped" mode would re-sign
        # adhoc with a new CDHash every build, losing TCC grants each time.
        package = lib.mkIf (!config.opts.variables.isDarwin) (
          lib.mkForce (config.lib.nixGL.wrapOffload inputs.zen-browser.packages."${system}".default)
        );
        darwin.packageMode = lib.mkIf config.opts.variables.isDarwin "signed";

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

          Preferences = mkLockedAttrs (
            {
              "browser.search.suggest.enabled" = true;
              "browser.tabs.closeWindowWithLastTab" = false;
              "zen.view.compact.should-enable-at-startup" = true;
              "zen.view.use-single-toolbar" = false;
              "zen.view.welcome-screen.seen" = true;
            }
            // lib.optionalAttrs config.opts.variables.isDarwin {
              # Suppress the "what's new" page after updates.
              "browser.startup.homepage_override.mstone" = "ignore";
            }
          );
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

          search = {
            engines = {
              github = {
                name = "GitHub";
                urls = [
                  {
                    template = "https://github.com/search?q={searchTerms}";
                  }
                ];
                definedAliases = ["@gh"];
              };
              nix = {
                name = "Nix";
                urls = [
                  {
                    template = "https://search.nixos.org/packages?query={searchTerms}";
                  }
                ];
                definedAliases = ["@nx"];
              };
            };
          };
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
          keyboardShortcutsVersion = 20;
          keyboardShortcuts = [
            # Sidebar
            {
              id = "toggleSidebarKb";
              key = "z";
              modifiers = {
                control = true;
              };
            }
            {
              id = "viewGenaiChatSidebarKb";
              key = "x";
              modifiers = {
                control = true;
              };
            }

            # Compact mode
            {
              id = "zen-compact-mode-toggle";
              key = "s";
              modifiers = {
                accel = true;
              };
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
              modifiers = {
                control = true;
              };
            }
            {
              id = "zen-workspace-switch-2";
              key = "2";
              modifiers = {
                control = true;
              };
            }
            {
              id = "zen-workspace-switch-3";
              key = "3";
              modifiers = {
                control = true;
              };
            }
            {
              id = "zen-workspace-switch-4";
              key = "4";
              modifiers = {
                control = true;
              };
            }
            {
              id = "zen-workspace-switch-5";
              key = "5";
              modifiers = {
                control = true;
              };
            }
            {
              id = "zen-workspace-switch-6";
              key = "6";
              modifiers = {
                control = true;
              };
            }
            {
              id = "zen-workspace-switch-7";
              key = "7";
              modifiers = {
                control = true;
              };
            }
            {
              id = "zen-workspace-switch-8";
              key = "8";
              modifiers = {
                control = true;
              };
            }
            {
              id = "zen-workspace-switch-9";
              key = "9";
              modifiers = {
                control = true;
              };
            }
            {
              id = "zen-workspace-switch-10";
              key = "0";
              modifiers = {
                control = true;
              };
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
              modifiers = {
                accel = true;
              };
            }
            {
              id = "key_toggleMute";
              key = "m";
              modifiers = {
                control = true;
              };
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
              mkWorkPin "c802ade4-2ae1-4231-b86d-564706855a18" "https://mail.google.com/mail/u/0/#inbox" "Inbox"
              100;
            "Calendar" =
              mkWorkPin "3a37bdb6-166a-427a-af2d-104bdc480e0d" "https://calendar.google.com/calendar/u/0r"
              "Corti - Calendar"
              200;
            "Drive" =
              mkWorkPin "f7c53ed5-446a-421d-b88a-8116d9439c96" "https://drive.google.com/drive/home"
              "Google Drive"
              300;
            "Linear" =
              mkWorkPin "ce58e497-05a3-437b-8973-ae6865f3284e" "https://linear.app/corti/team/AGENT/active"
              "Linear"
              400;
            "Azure" =
              mkWorkPin "414b03a4-aee3-41b3-95b6-377ed7e3d6bd" "https://portal.azure.com/#home" "Azure"
              500;
            "Navan" = mkWorkPin "9defc09b-ac85-4b10-ab52-a411314a7020" "https://app.navan.com" "Navan" 600;
            "Notion" =
              mkWorkPin "608dad79-ec7f-4b32-b37b-897036d947c2" "https://www.notion.so/cortihome" "Notion"
              700;
            "Datadog" =
              mkWorkPin "d2259d52-c0af-4dea-8582-0ff724ccb2f2"
              "https://app.datadoghq.eu/apm/home?graphType=flamegraph&personalized=false&shouldShowLegend=true&traceQuery="
              "Datadog APM"
              800;
            "Claude" = mkWorkPin "d8f99b35-175d-4123-bbc1-56b77eb9e4d5" "https://claude.ai/new" "Claude" 900;
            "Orca" =
              mkWorkPin "a22d9538-a7e1-4322-9d59-c24eb2a9afcc" "https://orca.corti.app/app/releases"
              "Orca Releases"
              1000;
            "GitHubStatus" =
              mkWorkPin "3bbb10c6-39e4-476e-b057-253f49242bac" "https://mrshu.github.io/github-statuses/"
              "GitHub Status"
              1100;
            "HiBob" = mkWorkPin "f47ac10b-58cc-4372-a567-0e02b2c3d479" "https://app.hibob.com" "HiBob" 1200;
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
              theme = {
                colors = [
                  (
                    hexToRgb colors.base0D
                    // {
                      algorithm = "floating";
                      type = "explicit-lightness";
                      lightness = 50;
                    }
                  )
                ];
                opacity = 0.3;
                texture = 0.0;
              };
              routes = {
                "discord" = {
                  reference = "discord";
                  matchType = "contains";
                };
              };
            };
            "Work" = {
              id = "73eca14a-5498-406d-845f-55439aa80f90";
              position = 2000;
              icon = "🏛️";
              container = containers."Work".id;
              theme = {
                colors = [
                  (
                    hexToRgb colors.base09
                    // {
                      algorithm = "floating";
                      type = "explicit-lightness";
                      lightness = 50;
                    }
                  )
                ];
                opacity = 0.3;
                texture = 0.0;
              };
              routes = {
                "linear" = {
                  reference = "linear.app";
                  matchType = "contains";
                };
                "github" = {
                  reference = "github.com";
                  matchType = "contains";
                };
                "notion" = {
                  reference = "notion.so";
                  matchType = "contains";
                };
                "navan" = {
                  reference = "app.navan.com";
                  matchType = "contains";
                };
                "datadog" = {
                  reference = "datadoghq.eu";
                  matchType = "contains";
                };
                "orca" = {
                  reference = "orca.corti.app";
                  matchType = "contains";
                };
                "corti" = {
                  reference = "corti";
                  matchType = "contains";
                };
              };
              liveFolders = {
                "Pull requests" = {
                  id = "b7a3d5c1-9e2f-4a68-b0d4-6f1c8e5a2d93";
                  kind = "github:pull-requests";
                  position = 401;
                  github = {
                    assignedMe = true;
                    reviewRequested = false;
                    authorMe = false;
                  };
                };
                "My issues" = {
                  id = "3c9e1f7a-5b24-4d80-9a6c-e2f4b8d10c57";
                  kind = "github:issues";
                  position = 402;
                  github = {
                    assignedMe = true;
                    authorMe = false;
                  };
                };
              };
            };
            "Alt" = {
              id = "a781d4e4-b7f6-4b9b-9324-b99d95c2f5f9";
              position = 3000;
              icon = "👁️‍🗨️";
              container = containers."Alt".id;
              theme = {
                colors = [
                  (
                    hexToRgb colors.base0E
                    // {
                      algorithm = "floating";
                      type = "explicit-lightness";
                      lightness = 50;
                    }
                  )
                ];
                opacity = 0.3;
                texture = 0.0;
              };
              routes = {
                "sharepoint" = {
                  reference = "sharepoint";
                  matchType = "contains";
                };
                "msadmin" = {
                  reference = "admin.microsoft";
                  matchType = "contains";
                };
              };
            };
          };
          spaceRouting = {
            force = true;
            defaultExternalRoute = "most-recent-space";
          };

          storeId = "b2373c55";
        };
      }
      // lib.optionalAttrs config.opts.variables.isDarwin {
        darwinDefaultsId = "app.zen-browser.zen";
      };

    # Clean stale install-hash entries from installs.ini and re-register the app
    # with LaunchServices after each rebuild. On Darwin, profiles.ini is a
    # read-only Nix store symlink, so Zen can't update it after an update —
    # it writes a new install hash to installs.ini instead, leaving stale
    # entries that trigger the profile-picker "dance". GC'd nix store paths
    # also break LaunchServices registration, losing the default-browser
    # link.
    home.activation = lib.mkIf config.opts.variables.isDarwin (
      let
        zenConfigDir = "${config.home.homeDirectory}/Library/Application Support/Zen";
        installsFile = "${zenConfigDir}/installs.ini";
        # The signed .app is installed by home-manager into ~/Applications/Home Manager Apps/
        # and a trampoline is created in ~/Applications/Home Manager Trampolines/.
        # Re-registering both keeps LaunchServices and TCC in sync after updates.
        lsregister = "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister";
      in {
        zenCleanupInstallsIni = lib.hm.dag.entryAfter ["writeBoundary" "zen-browser-${profileName}"] ''
          if [ -f "${installsFile}" ]; then
            tmp=$(mktemp)
            ${pkgs.gawk}/bin/awk -v want="Default=Profiles/${profileName}" '
              BEGIN { RS=""; FS="\n" }
              {
                keep = 0
                for (i=1; i<=NF; i++) {
                  if ($i == want) { keep = 1; break }
                }
                if (keep) print $0 "\n"
              }
            ' "${installsFile}" > "$tmp" && mv "$tmp" "${installsFile}"
            $VERBOSE_ECHO "zen: Cleaned stale installs.ini entries"
          fi
        '';

        zenRegisterLaunchServices = lib.hm.dag.entryAfter ["writeBoundary" "trampolineApps"] ''
          for app in \
            "$HOME/Applications/Home Manager Apps/Zen Browser (Twilight).app" \
            "$HOME/Applications/Home Manager Trampolines/Zen Browser (Twilight).app"; do
            if [ -d "$app" ]; then
              ${lsregister} -f "$app" 2>/dev/null || true
            fi
          done
          $VERBOSE_ECHO "zen: Re-registered Zen Browser with LaunchServices"
        '';
      }
    );
  };
}
