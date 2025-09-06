{
  inputs,
  system,
  config,
  lib,
  ...
}: let
  inherit (config.lib.stylix) colors;
  inherit (config.stylix) fonts;

  mkLockedAttrs = builtins.mapAttrs (_: value: {
    Value = value;
    Status = "locked";
  });
in {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;
    package = lib.mkForce (config.lib.nixGL.wrapOffload inputs.zen-browser.packages."${system}".default);

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

    profiles."default" = {
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
        School = {
          color = "pink";
          icon = "chill";
          id = 6;
        };
      };
      spacesForce = true;
      spaces = let
        containers = config.programs.zen-browser.profiles."default".containers;
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
        "School" = {
          id = "2453db27-d5b0-44e8-85f1-e7c6fa1483be";
          position = 3000;
          icon = "🎓️";
          container = containers."School".id;
        };
      };

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.search.suggest.enabled" = true;
        "browser.tabs.closeWindowWithLastTab" = false;
        "zen.view.compact.should-enable-at-startup" = true;
        "zen.view.use-single-toolbar" = false;
        "zen.view.welcome-screen.seen" = true;
      };

      userChrome = import ./userChrome.nix {inherit colors;};
      # userContent = import ./userContent.nix {inherit colors;};
    };
  };
}
