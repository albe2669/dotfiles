#!/usr/bin/env python3
"""
Extract non-default macOS settings and convert to nix-darwin configuration.

Usage:
  python3 macos-to-nix-darwin.py              # output nix config
  python3 macos-to-nix-darwin.py --all        # include settings matching defaults
  python3 macos-to-nix-darwin.py --json       # output raw extracted values as JSON
  python3 macos-to-nix-darwin.py --custom     # include unknown keys as CustomUserPreferences
"""

import json
import subprocess
import sys
from dataclasses import dataclass, field
from typing import Any

# ---------------------------------------------------------------------------
# Nix-darwin option mappings
# Format: (domain, key, nix_path, type, default_value)
# type: "bool", "int", "float", "string", "enum"
# default_value: macOS factory default (None = no known default / always output)
# ---------------------------------------------------------------------------

@dataclass
class Option:
    domain: str
    key: str
    nix_path: str         # e.g. "dock.autohide"
    typ: str              # "bool" | "int" | "float" | "string"
    default: Any = None   # None means "always include if set"

KNOWN_OPTIONS: list[Option] = [
    # ── Dock ────────────────────────────────────────────────────────────────
    Option("com.apple.dock", "autohide",                      "dock.autohide",                         "bool",   False),
    Option("com.apple.dock", "autohide-delay",                "dock.autohide-delay",                   "float",  0.2),
    Option("com.apple.dock", "autohide-time-modifier",        "dock.autohide-time-modifier",           "float",  1.0),
    Option("com.apple.dock", "dashboard-in-overlay",          "dock.dashboard-in-overlay",             "bool",   False),
    Option("com.apple.dock", "enable-spring-load-actions-on-all-items", "dock.enable-spring-load-actions-on-all-items", "bool", False),
    Option("com.apple.dock", "expose-animation-duration",     "dock.expose-animation-duration",        "float",  None),
    Option("com.apple.dock", "expose-group-by-app",           "dock.expose-group-apps",                "bool",   True),
    Option("com.apple.dock", "launchanim",                    "dock.launchanim",                       "bool",   True),
    Option("com.apple.dock", "mineffect",                     "dock.mineffect",                        "string", "genie"),
    Option("com.apple.dock", "minimize-to-application",       "dock.minimize-to-application",          "bool",   False),
    Option("com.apple.dock", "mouse-over-hilite-stack",       "dock.mouse-over-hilite-stack",          "bool",   None),
    Option("com.apple.dock", "mru-spaces",                    "dock.mru-spaces",                       "bool",   True),
    Option("com.apple.dock", "orientation",                   "dock.orientation",                      "string", "bottom"),
    Option("com.apple.dock", "show-recents",                  "dock.show-recents",                     "bool",   True),
    Option("com.apple.dock", "showhidden",                    "dock.showhidden",                       "bool",   False),
    Option("com.apple.dock", "static-only",                   "dock.static-only",                      "bool",   False),
    Option("com.apple.dock", "tilesize",                      "dock.tilesize",                         "int",    64),
    Option("com.apple.dock", "wvous-bl-corner",               "dock.wvous-bl-corner",                  "int",    None),
    Option("com.apple.dock", "wvous-br-corner",               "dock.wvous-br-corner",                  "int",    None),
    Option("com.apple.dock", "wvous-tl-corner",               "dock.wvous-tl-corner",                  "int",    None),
    Option("com.apple.dock", "wvous-tr-corner",               "dock.wvous-tr-corner",                  "int",    None),

    # ── Finder ──────────────────────────────────────────────────────────────
    Option("com.apple.finder", "_FXShowPosixPathInTitle",      "finder._FXShowPosixPathInTitle",         "bool",   False),
    Option("com.apple.finder", "_FXSortFoldersFirst",          "finder._FXSortFoldersFirst",              "bool",   False),
    Option("com.apple.finder", "_FXSortFoldersFirstOnDesktop", "finder._FXSortFoldersFirstOnDesktop",    "bool",   False),
    Option("com.apple.finder", "AppleShowAllExtensions",       "finder.AppleShowAllExtensions",           "bool",   False),
    Option("com.apple.finder", "AppleShowAllFiles",            "finder.AppleShowAllFiles",                "bool",   False),
    Option("com.apple.finder", "CreateDesktop",                "finder.CreateDesktop",                    "bool",   True),
    Option("com.apple.finder", "FXDefaultSearchScope",         "finder.FXDefaultSearchScope",             "string", "SCev"),
    Option("com.apple.finder", "FXEnableExtensionChangeWarning", "finder.FXEnableExtensionChangeWarning", "bool",   True),
    Option("com.apple.finder", "FXICloudDriveDesktop",         "finder.FXICloudDriveDesktop",             "bool",   None),
    Option("com.apple.finder", "FXICloudDriveDocuments",       "finder.FXICloudDriveDocuments",           "bool",   None),
    Option("com.apple.finder", "FXICloudDriveEnabled",         "finder.FXICloudDriveEnabled",             "bool",   None),
    Option("com.apple.finder", "FXPreferredViewStyle",         "finder.FXPreferredViewStyle",             "string", "icnv"),
    Option("com.apple.finder", "FXRemoveOldTrashItems",        "finder.FXRemoveOldTrashItems",            "bool",   False),
    Option("com.apple.finder", "NewWindowTarget",              "finder.NewWindowTarget",                  "string", "PfHm"),
    Option("com.apple.finder", "NewWindowTargetPath",          "finder.NewWindowTargetPath",              "string", None),
    Option("com.apple.finder", "QuitMenuItem",                 "finder.QuitMenuItem",                     "bool",   False),
    Option("com.apple.finder", "ShowExternalHardDrivesOnDesktop", "finder.ShowExternalHardDrivesOnDesktop", "bool", True),
    Option("com.apple.finder", "ShowHardDrivesOnDesktop",      "finder.ShowHardDrivesOnDesktop",          "bool",   False),
    Option("com.apple.finder", "ShowMountedServersOnDesktop",  "finder.ShowMountedServersOnDesktop",      "bool",   False),
    Option("com.apple.finder", "ShowPathbar",                  "finder.ShowPathbar",                      "bool",   False),
    Option("com.apple.finder", "ShowRemovableMediaOnDesktop",  "finder.ShowRemovableMediaOnDesktop",      "bool",   True),
    Option("com.apple.finder", "ShowStatusBar",                "finder.ShowStatusBar",                    "bool",   False),

    # ── NSGlobalDomain ──────────────────────────────────────────────────────
    Option("NSGlobalDomain", "AppleEnableMouseSwipeNavigateWithScrolls", "NSGlobalDomain.AppleEnableMouseSwipeNavigateWithScrolls", "bool", True),
    Option("NSGlobalDomain", "AppleEnableSwipeNavigateWithScrolls",      "NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls",      "bool", True),
    Option("NSGlobalDomain", "AppleFontSmoothing",                        "NSGlobalDomain.AppleFontSmoothing",                        "int",  None),
    Option("NSGlobalDomain", "AppleICUForce24HourTime",                   "NSGlobalDomain.AppleICUForce24HourTime",                   "bool", None),
    Option("NSGlobalDomain", "AppleInterfaceStyle",                       "NSGlobalDomain.AppleInterfaceStyle",                       "string", None),
    Option("NSGlobalDomain", "AppleInterfaceStyleSwitchesAutomatically",  "NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically",  "bool", False),
    Option("NSGlobalDomain", "AppleKeyboardUIMode",                       "NSGlobalDomain.AppleKeyboardUIMode",                       "int",  None),
    Option("NSGlobalDomain", "AppleMeasurementUnits",                     "NSGlobalDomain.AppleMeasurementUnits",                     "string", None),
    Option("NSGlobalDomain", "AppleMetricUnits",                          "NSGlobalDomain.AppleMetricUnits",                          "int",  None),
    Option("NSGlobalDomain", "ApplePressAndHoldEnabled",                  "NSGlobalDomain.ApplePressAndHoldEnabled",                  "bool", True),
    Option("NSGlobalDomain", "AppleScrollerPagingBehavior",               "NSGlobalDomain.AppleScrollerPagingBehavior",               "bool", False),
    Option("NSGlobalDomain", "AppleShowAllExtensions",                    "NSGlobalDomain.AppleShowAllExtensions",                    "bool", False),
    Option("NSGlobalDomain", "AppleShowScrollBars",                       "NSGlobalDomain.AppleShowScrollBars",                       "string", "Automatic"),
    Option("NSGlobalDomain", "AppleSpacesSwitchOnActivate",               "NSGlobalDomain.AppleSpacesSwitchOnActivate",               "bool", True),
    Option("NSGlobalDomain", "AppleTemperatureUnit",                      "NSGlobalDomain.AppleTemperatureUnit",                      "string", None),
    Option("NSGlobalDomain", "AppleWindowTabbingMode",                    "NSGlobalDomain.AppleWindowTabbingMode",                    "string", "automatic"),
    Option("NSGlobalDomain", "InitialKeyRepeat",                          "NSGlobalDomain.InitialKeyRepeat",                          "int",  68),
    Option("NSGlobalDomain", "KeyRepeat",                                 "NSGlobalDomain.KeyRepeat",                                 "int",  6),
    Option("NSGlobalDomain", "NSAutomaticCapitalizationEnabled",          "NSGlobalDomain.NSAutomaticCapitalizationEnabled",          "bool", True),
    Option("NSGlobalDomain", "NSAutomaticDashSubstitutionEnabled",        "NSGlobalDomain.NSAutomaticDashSubstitutionEnabled",        "bool", True),
    Option("NSGlobalDomain", "NSAutomaticPeriodSubstitutionEnabled",      "NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled",      "bool", True),
    Option("NSGlobalDomain", "NSAutomaticQuoteSubstitutionEnabled",       "NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled",       "bool", True),
    Option("NSGlobalDomain", "NSAutomaticSpellingCorrectionEnabled",      "NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled",      "bool", True),
    Option("NSGlobalDomain", "NSDisableAutomaticTermination",             "NSGlobalDomain.NSDisableAutomaticTermination",             "bool", None),
    Option("NSGlobalDomain", "NSDocumentSaveNewDocumentsToCloud",         "NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud",         "bool", True),
    Option("NSGlobalDomain", "NSNavPanelExpandedStateForSaveMode",        "NSGlobalDomain.NSNavPanelExpandedStateForSaveMode",        "bool", False),
    Option("NSGlobalDomain", "NSNavPanelExpandedStateForSaveMode2",       "NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2",       "bool", False),
    Option("NSGlobalDomain", "NSScrollAnimationEnabled",                  "NSGlobalDomain.NSScrollAnimationEnabled",                  "bool", None),
    Option("NSGlobalDomain", "NSTableViewDefaultSizeMode",                "NSGlobalDomain.NSTableViewDefaultSizeMode",                "int",  3),
    Option("NSGlobalDomain", "NSTextShowsControlCharacters",              "NSGlobalDomain.NSTextShowsControlCharacters",              "bool", None),
    Option("NSGlobalDomain", "NSUseAnimatedFocusRing",                    "NSGlobalDomain.NSUseAnimatedFocusRing",                    "bool", None),
    Option("NSGlobalDomain", "NSWindowResizeTime",                        "NSGlobalDomain.NSWindowResizeTime",                        "float", 0.2),
    Option("NSGlobalDomain", "NSWindowShouldDragOnGesture",               "NSGlobalDomain.NSWindowShouldDragOnGesture",               "bool", False),
    Option("NSGlobalDomain", "PMPrintingExpandedStateForPrint",           "NSGlobalDomain.PMPrintingExpandedStateForPrint",           "bool", False),
    Option("NSGlobalDomain", "PMPrintingExpandedStateForPrint2",          "NSGlobalDomain.PMPrintingExpandedStateForPrint2",          "bool", False),
    Option("NSGlobalDomain", "com.apple.keyboard.fnState",                "NSGlobalDomain.\"com.apple.keyboard.fnState\"",            "bool", None),
    Option("NSGlobalDomain", "com.apple.mouse.tapBehavior",               "NSGlobalDomain.\"com.apple.mouse.tapBehavior\"",           "int",  None),
    Option("NSGlobalDomain", "com.apple.sound.beep.feedback",             "NSGlobalDomain.\"com.apple.sound.beep.feedback\"",         "int",  None),
    Option("NSGlobalDomain", "com.apple.sound.beep.volume",               "NSGlobalDomain.\"com.apple.sound.beep.volume\"",           "float", None),
    Option("NSGlobalDomain", "com.apple.springing.delay",                 "NSGlobalDomain.\"com.apple.springing.delay\"",             "float", None),
    Option("NSGlobalDomain", "com.apple.springing.enabled",               "NSGlobalDomain.\"com.apple.springing.enabled\"",           "bool", None),
    Option("NSGlobalDomain", "com.apple.swipescrolldirection",            "NSGlobalDomain.\"com.apple.swipescrolldirection\"",        "bool", True),
    Option("NSGlobalDomain", "com.apple.trackpad.forceClick",             "NSGlobalDomain.\"com.apple.trackpad.forceClick\"",         "int",  None),
    Option("NSGlobalDomain", "com.apple.trackpad.scaling",                "NSGlobalDomain.\"com.apple.trackpad.scaling\"",            "float", None),

    # ── Trackpad ────────────────────────────────────────────────────────────
    Option("com.apple.AppleMultitouchTrackpad", "ActuationStrength",        "trackpad.ActuationStrength",        "int",  None),
    Option("com.apple.AppleMultitouchTrackpad", "Clicking",                 "trackpad.Clicking",                  "bool", False),
    Option("com.apple.AppleMultitouchTrackpad", "Dragging",                 "trackpad.Dragging",                  "bool", False),
    Option("com.apple.AppleMultitouchTrackpad", "FirstClickThreshold",      "trackpad.FirstClickThreshold",       "int",  1),
    Option("com.apple.AppleMultitouchTrackpad", "SecondClickThreshold",     "trackpad.SecondClickThreshold",      "int",  1),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadCornerSecondaryClick", "trackpad.TrackpadCornerSecondaryClick", "int", None),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadFiveFingerPinchGesture", "trackpad.TrackpadFiveFingerPinchGesture", "int", None),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadFourFingerHorizSwipeGesture", "trackpad.TrackpadFourFingerHorizSwipeGesture", "int", None),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadFourFingerPinchGesture", "trackpad.TrackpadFourFingerPinchGesture", "int", None),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadFourFingerVertSwipeGesture", "trackpad.TrackpadFourFingerVertSwipeGesture", "int", None),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadHandResting",      "trackpad.TrackpadHandResting",       "bool", None),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadHorizScroll",      "trackpad.TrackpadHorizScroll",       "bool", None),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadMomentumScroll",   "trackpad.TrackpadMomentumScroll",    "bool", None),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadPinch",            "trackpad.TrackpadPinch",             "bool", None),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadRightClick",       "trackpad.TrackpadRightClick",        "bool", True),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadRotate",           "trackpad.TrackpadRotate",            "bool", None),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadScroll",           "trackpad.TrackpadScroll",            "bool", None),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadThreeFingerDrag",  "trackpad.TrackpadThreeFingerDrag",   "bool", False),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadThreeFingerHorizSwipeGesture", "trackpad.TrackpadThreeFingerHorizSwipeGesture", "int", None),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadThreeFingerTapGesture", "trackpad.TrackpadThreeFingerTapGesture", "int", None),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadThreeFingerVertSwipeGesture", "trackpad.TrackpadThreeFingerVertSwipeGesture", "int", None),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadTwoFingerDoubleTapGesture", "trackpad.TrackpadTwoFingerDoubleTapGesture", "int", None),
    Option("com.apple.AppleMultitouchTrackpad", "TrackpadTwoFingerFromRightEdgeSwipeGesture", "trackpad.TrackpadTwoFingerFromRightEdgeSwipeGesture", "int", None),
    Option("com.apple.AppleMultitouchTrackpad", "USBMouseStopsTrackpad",    "trackpad.USBMouseStopsTrackpad",     "bool", None),

    # ── Screen capture ──────────────────────────────────────────────────────
    Option("com.apple.screencapture", "disable-shadow",   "screencapture.disable-shadow",   "bool",   False),
    Option("com.apple.screencapture", "include-date",     "screencapture.include-date",      "bool",   True),
    Option("com.apple.screencapture", "location",         "screencapture.location",          "string", None),
    Option("com.apple.screencapture", "show-thumbnail",   "screencapture.show-thumbnail",    "bool",   True),
    Option("com.apple.screencapture", "target",           "screencapture.target",            "string", "file"),
    Option("com.apple.screencapture", "type",             "screencapture.type",              "string", "png"),

    # ── Screensaver ─────────────────────────────────────────────────────────
    Option("com.apple.screensaver", "askForPassword",      "screensaver.askForPassword",      "int",  0),
    Option("com.apple.screensaver", "askForPasswordDelay", "screensaver.askForPasswordDelay", "int",  0),

    # ── Spaces ──────────────────────────────────────────────────────────────
    Option("com.apple.spaces", "spans-displays", "spaces.spans-displays", "bool", False),

    # ── Accessibility ───────────────────────────────────────────────────────
    Option("com.apple.universalaccess", "closeViewScrollWheelToggle",    "universalaccess.closeViewScrollWheelToggle",    "bool", False),
    Option("com.apple.universalaccess", "HIDScrollZoomModifierMask",     "universalaccess.HIDScrollZoomModifierMask",     "int",  None),
    Option("com.apple.universalaccess", "mouseDriverCursorSize",         "universalaccess.mouseDriverCursorSize",         "float", 1.0),
    Option("com.apple.universalaccess", "reduceMotion",                  "universalaccess.reduceMotion",                  "bool", False),
    Option("com.apple.universalaccess", "reduceTransparency",            "universalaccess.reduceTransparency",            "bool", False),
    Option("com.apple.universalaccess", "slowKey",                       "universalaccess.slowKey",                       "bool", False),
    Option("com.apple.universalaccess", "slowKeyBeep",                   "universalaccess.slowKeyBeep",                   "bool", None),
    Option("com.apple.universalaccess", "slowKeyDelay",                  "universalaccess.slowKeyDelay",                  "int",  None),

    # ── Login window ────────────────────────────────────────────────────────
    Option("com.apple.loginwindow", "DisableConsoleAccess",             "loginwindow.DisableConsoleAccess",              "bool", False),
    Option("com.apple.loginwindow", "GuestEnabled",                     "loginwindow.GuestEnabled",                      "bool", False),
    Option("com.apple.loginwindow", "LoginwindowText",                  "loginwindow.LoginwindowText",                   "string", None),
    Option("com.apple.loginwindow", "PowerOffDisabledWhileLoggedIn",    "loginwindow.PowerOffDisabledWhileLoggedIn",     "bool", False),
    Option("com.apple.loginwindow", "RestartDisabled",                  "loginwindow.RestartDisabled",                   "bool", False),
    Option("com.apple.loginwindow", "RestartDisabledWhileLoggedIn",     "loginwindow.RestartDisabledWhileLoggedIn",      "bool", False),
    Option("com.apple.loginwindow", "SHOWFULLNAME",                     "loginwindow.SHOWFULLNAME",                      "bool", False),
    Option("com.apple.loginwindow", "ShutDownDisabled",                 "loginwindow.ShutDownDisabled",                  "bool", False),
    Option("com.apple.loginwindow", "ShutDownDisabledWhileLoggedIn",    "loginwindow.ShutDownDisabledWhileLoggedIn",     "bool", False),
    Option("com.apple.loginwindow", "SleepDisabled",                    "loginwindow.SleepDisabled",                     "bool", False),

    # ── Menu bar clock ──────────────────────────────────────────────────────
    Option("com.apple.menuextra.clock", "Show24Hour",      "menuExtraClock.Show24Hour",      "bool", None),
    Option("com.apple.menuextra.clock", "ShowAMPM",        "menuExtraClock.ShowAMPM",        "bool", None),
    Option("com.apple.menuextra.clock", "ShowDate",        "menuExtraClock.ShowDate",        "int",  None),
    Option("com.apple.menuextra.clock", "ShowDayOfMonth",  "menuExtraClock.ShowDayOfMonth",  "bool", None),
    Option("com.apple.menuextra.clock", "ShowDayOfWeek",   "menuExtraClock.ShowDayOfWeek",   "bool", None),
    Option("com.apple.menuextra.clock", "ShowSeconds",     "menuExtraClock.ShowSeconds",     "bool", None),

    # ── Software Update ─────────────────────────────────────────────────────
    Option("com.apple.SoftwareUpdate", "AutomaticallyInstallMacOSUpdates", "SoftwareUpdate.AutomaticallyInstallMacOSUpdates", "bool", None),

    # ── Firewall (alf) ──────────────────────────────────────────────────────
    Option("com.apple.alf", "allowdownloadsignedenabled", "alf.allowdownloadsignedenabled", "int", None),
    Option("com.apple.alf", "allowsignedenabled",         "alf.allowsignedenabled",         "int", None),
    Option("com.apple.alf", "globalstate",                "alf.globalstate",                "int", 0),
    Option("com.apple.alf", "loggingenabled",             "alf.loggingenabled",             "int", None),
    Option("com.apple.alf", "stealthenabled",             "alf.stealthenabled",             "int", None),

    # ── Activity Monitor ────────────────────────────────────────────────────
    Option("com.apple.ActivityMonitor", "IconType",       "ActivityMonitor.IconType",       "int",    None),
    Option("com.apple.ActivityMonitor", "OpenMainWindow", "ActivityMonitor.OpenMainWindow",  "bool",   None),
    Option("com.apple.ActivityMonitor", "ShowCategory",   "ActivityMonitor.ShowCategory",    "int",    None),
    Option("com.apple.ActivityMonitor", "SortColumn",     "ActivityMonitor.SortColumn",      "string", None),
    Option("com.apple.ActivityMonitor", "SortDirection",  "ActivityMonitor.SortDirection",   "int",    None),

    # ── HIToolbox (Fn key) ──────────────────────────────────────────────────
    Option("com.apple.HIToolbox", "AppleFnUsageType", "hitoolbox.AppleFnUsageType", "int", None),

    # ── Magic Mouse ─────────────────────────────────────────────────────────
    Option("com.apple.driver.AppleBluetoothMultitouch.mouse", "MouseButtonMode",                 "magicmouse.MouseButtonMode",                 "string", None),
    Option("com.apple.driver.AppleBluetoothMultitouch.mouse", "MouseHorizontalScroll",            "magicmouse.MouseHorizontalScroll",            "bool",   None),
    Option("com.apple.driver.AppleBluetoothMultitouch.mouse", "MouseMomentumScroll",              "magicmouse.MouseMomentumScroll",              "bool",   None),
    Option("com.apple.driver.AppleBluetoothMultitouch.mouse", "MouseOneFingerDoubleTapGesture",   "magicmouse.MouseOneFingerDoubleTapGesture",   "int",    None),
    Option("com.apple.driver.AppleBluetoothMultitouch.mouse", "MouseTwoFingerDoubleTapGesture",   "magicmouse.MouseTwoFingerDoubleTapGesture",   "int",    None),
    Option("com.apple.driver.AppleBluetoothMultitouch.mouse", "MouseTwoFingerHorizSwipeGesture",  "magicmouse.MouseTwoFingerHorizSwipeGesture",  "int",    None),
    Option("com.apple.driver.AppleBluetoothMultitouch.mouse", "UserPreferences",                  "magicmouse.UserPreferences",                  "bool",   None),
]

# ---------------------------------------------------------------------------
# Domains to scan for CustomUserPreferences
# ---------------------------------------------------------------------------
CUSTOM_DOMAINS = [
    "com.apple.dock",
    "com.apple.finder",
    "NSGlobalDomain",
    "com.apple.AppleMultitouchTrackpad",
    "com.apple.driver.AppleBluetoothMultitouch.trackpad",
    "com.apple.driver.AppleBluetoothMultitouch.mouse",
    "com.apple.screencapture",
    "com.apple.screensaver",
    "com.apple.spaces",
    "com.apple.universalaccess",
    "com.apple.loginwindow",
    "com.apple.menuextra.clock",
    "com.apple.SoftwareUpdate",
    "com.apple.ActivityMonitor",
    "com.apple.HIToolbox",
    "com.apple.alf",
]

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def defaults_read(domain: str, key: str) -> Any:
    """Read a single defaults key; returns None if not set."""
    try:
        result = subprocess.run(
            ["defaults", "read", domain, key],
            capture_output=True, text=True, check=True
        )
        raw = result.stdout.strip()
        return raw
    except subprocess.CalledProcessError:
        return None


def defaults_read_domain(domain: str) -> dict[str, str]:
    """Read all keys from a domain via `defaults export`. Returns {key: raw_string}."""
    try:
        result = subprocess.run(
            ["defaults", "export", domain, "-"],
            capture_output=True, check=True
        )
        import plistlib
        plist = plistlib.loads(result.stdout)
        return {k: v for k, v in plist.items()}
    except Exception:
        return {}


def coerce(raw: str, typ: str) -> Any:
    """Convert a raw defaults string to a Python value."""
    if raw is None:
        return None
    raw = raw.strip()
    if typ == "bool":
        return raw in ("1", "true", "YES", "True")
    if typ == "int":
        try:
            return int(raw)
        except ValueError:
            return None
    if typ == "float":
        try:
            return float(raw)
        except ValueError:
            return None
    return raw  # string


def nix_value(val: Any, typ: str) -> str:
    """Format a Python value as a Nix expression."""
    if typ == "bool":
        return "true" if val else "false"
    if typ == "float":
        # nix-darwin accepts floats as strings in most options
        return f'"{val}"'
    if typ == "string":
        escaped = str(val).replace("\\", "\\\\").replace('"', '\\"')
        return f'"{escaped}"'
    return str(val)


def differs_from_default(val: Any, default: Any, typ: str) -> bool:
    """Return True if val differs from the known macOS default."""
    if default is None:
        return True  # no known default → always include
    if typ in ("bool", "int", "float"):
        return val != default
    return str(val) != str(default)


# ---------------------------------------------------------------------------
# Key remapping (hidutil)
# ---------------------------------------------------------------------------

def get_key_remappings() -> list[dict]:
    """Return the current hidutil UserKeyMapping entries."""
    try:
        result = subprocess.run(
            ["hidutil", "property", "--get", "UserKeyMapping"],
            capture_output=True, text=True, check=True
        )
        raw = result.stdout.strip()
        # Output looks like:  (  { HIDKeyboardModifierMappingDst = ...; HIDKeyboardModifierMappingSrc = ...; } )
        import re
        entries = []
        for block in re.findall(r'\{([^}]+)\}', raw):
            src = re.search(r'HIDKeyboardModifierMappingSrc\s*=\s*([0-9]+)', block)
            dst = re.search(r'HIDKeyboardModifierMappingDst\s*=\s*([0-9]+)', block)
            if src and dst:
                entries.append({
                    "HIDKeyboardModifierMappingSrc": int(src.group(1)),
                    "HIDKeyboardModifierMappingDst": int(dst.group(1)),
                })
        return entries
    except Exception:
        return []


# ---------------------------------------------------------------------------
# Display settings (via system_profiler / screenresolution)
# ---------------------------------------------------------------------------

def get_display_info() -> list[dict]:
    """Return display info as dicts (name, resolution, refresh, scaled)."""
    try:
        result = subprocess.run(
            ["system_profiler", "SPDisplaysDataType", "-json"],
            capture_output=True, text=True, check=True
        )
        data = json.loads(result.stdout)
        displays = []
        for gpu in data.get("SPDisplaysDataType", []):
            for disp in gpu.get("spdisplays_ndrvs", []):
                resolution = disp.get("_spdisplays_resolution", "")
                refresh = disp.get("spdisplays_refresh-rate", "")
                scaled = disp.get("spdisplays_pixelresolution", "")
                displays.append({
                    "name": disp.get("_name", "Unknown"),
                    "resolution": resolution,
                    "refresh": refresh,
                    "scaled": scaled,
                    "ui_looks_like": disp.get("spdisplays_resolution", ""),
                })
        return displays
    except Exception:
        return []


# ---------------------------------------------------------------------------
# Collect everything
# ---------------------------------------------------------------------------

def collect() -> dict:
    """Collect all settings and return a structured dict."""
    settings: dict[str, Any] = {}
    custom: dict[str, dict[str, Any]] = {}

    # Read all known options
    for opt in KNOWN_OPTIONS:
        raw = defaults_read(opt.domain, opt.key)
        if raw is None:
            continue
        val = coerce(raw, opt.typ)
        if val is None:
            continue
        settings[opt.nix_path] = {
            "value": val,
            "raw": raw,
            "type": opt.typ,
            "default": opt.default,
            "changed": differs_from_default(val, opt.default, opt.typ),
        }

    # Key remappings
    remappings = get_key_remappings()
    if remappings:
        settings["__key_remappings"] = remappings

    # Display info
    displays = get_display_info()
    if displays:
        settings["__displays"] = displays

    # Custom domain scan (collect keys not in KNOWN_OPTIONS)
    known_keys: dict[str, set] = {}
    for opt in KNOWN_OPTIONS:
        known_keys.setdefault(opt.domain, set()).add(opt.key)

    for domain in CUSTOM_DOMAINS:
        all_keys = defaults_read_domain(domain)
        extra = {k: v for k, v in all_keys.items()
                 if k not in known_keys.get(domain, set())}
        if extra:
            custom[domain] = extra

    settings["__custom_domains"] = custom
    return settings


# ---------------------------------------------------------------------------
# Nix output
# ---------------------------------------------------------------------------

NIX_PATH_GROUPS = {
    "dock": [],
    "finder": [],
    "NSGlobalDomain": [],
    "trackpad": [],
    "screencapture": [],
    "screensaver": [],
    "spaces": [],
    "universalaccess": [],
    "loginwindow": [],
    "menuExtraClock": [],
    "SoftwareUpdate": [],
    "alf": [],
    "ActivityMonitor": [],
    "hitoolbox": [],
    "magicmouse": [],
}


def generate_nix(settings: dict, include_all: bool, include_custom: bool) -> str:
    """Generate a nix-darwin system.defaults block."""
    groups: dict[str, list[tuple[str, str]]] = {}

    for opt in KNOWN_OPTIONS:
        info = settings.get(opt.nix_path)
        if info is None:
            continue
        if not include_all and not info["changed"]:
            continue
        group = opt.nix_path.split(".")[0]
        key = ".".join(opt.nix_path.split(".")[1:])
        nv = nix_value(info["value"], info["type"])
        groups.setdefault(group, []).append((key, nv, info["type"]))

    lines = ['{ lib, ... }:', '{', '  system.defaults = {']

    for group, entries in sorted(groups.items()):
        if not entries:
            continue
        lines.append(f'    {group} = {{')
        for key, val, typ in entries:
            comment = '  # float — nix-darwin expects a string here' if typ == "float" else ''
            lines.append(f'      {key} = {val};{comment}')
        lines.append('    };')
        lines.append('')

    # Key remappings
    remappings = settings.get("__key_remappings", [])
    if remappings:
        lines.append('  };  # end system.defaults')
        lines.append('')
        lines.append('  # Key remappings (hidutil)')
        lines.append('  system.keyboard = {')
        lines.append('    enableKeyMapping = true;')
        lines.append('    userKeyMapping = [')
        for r in remappings:
            src = r["HIDKeyboardModifierMappingSrc"]
            dst = r["HIDKeyboardModifierMappingDst"]
            lines.append('      {')
            lines.append(f'        HIDKeyboardModifierMappingSrc = {src};')
            lines.append(f'        HIDKeyboardModifierMappingDst = {dst};')
            lines.append('      }')
        lines.append('    ];')
        lines.append('  };')
    else:
        lines.append('  };  # end system.defaults')

    # Custom user preferences
    if include_custom:
        custom = settings.get("__custom_domains", {})
        if any(custom.values()):
            lines.append('')
            lines.append('  # Unknown keys — verify before using')
            lines.append('  # system.defaults.CustomUserPreferences = {')
            for domain, keys in sorted(custom.items()):
                if not keys:
                    continue
                lines.append(f'  #   "{domain}" = {{')
                for k, v in sorted(keys.items()):
                    try:
                        nv = json.dumps(v)
                    except TypeError:
                        nv = f'"{v}"'
                    lines.append(f'  #     "{k}" = {nv};  # raw value')
                lines.append('  #   };')
            lines.append('  # };')

    lines.append('}')
    return '\n'.join(lines)


# ---------------------------------------------------------------------------
# Display info comment
# ---------------------------------------------------------------------------

def display_comment(displays: list[dict]) -> str:
    if not displays:
        return ""
    lines = ["# Display configuration (read-only info — nix-darwin cannot manage this):"]
    for d in displays:
        lines.append(f"#   {d['name']}: {d['resolution']} {d['refresh']} scaled={d['scaled']}")
    return '\n'.join(lines)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    include_all = "--all" in sys.argv
    as_json = "--json" in sys.argv
    include_custom = "--custom" in sys.argv

    print("Collecting macOS settings...", file=sys.stderr)
    settings = collect()

    if as_json:
        # Serialize: replace non-JSON-serializable types
        def _default(o):
            return str(o)
        print(json.dumps(settings, indent=2, default=_default))
        return

    displays = settings.pop("__displays", [])
    disp_comment = display_comment(displays)

    nix = generate_nix(settings, include_all, include_custom)

    if disp_comment:
        print(disp_comment)
        print()
    print(nix)


if __name__ == "__main__":
    main()
