{lib, ...}: {
  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      minimize-to-application = true;
      expose-animation-duration = 0.0;
      expose-group-apps = true;
    };

    finder = {
      AppleShowAllExtensions = true;
      QuitMenuItem = true;
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";

      AppleShowAllExtensions = true;

      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 14;
      KeyRepeat = 1;

      NSWindowShouldDragOnGesture = true;
      "com.apple.keyboard.fnState" = true;
      "com.apple.springing.delay" = 0.5;
      "com.apple.springing.enabled" = true;
      "com.apple.trackpad.forceClick" = true;
    };

    ActivityMonitor = {
      OpenMainWindow = false;
      ShowCategory = 102;
    };

    menuExtraClock = {
      ShowAMPM = true;
      ShowDate = 0;
      ShowDayOfWeek = true;
    };

    spaces = {
      spans-displays = true;
    };

    trackpad = {
      Clicking = true;
      TrackpadCornerSecondaryClick = 0;
      TrackpadFourFingerHorizSwipeGesture = 2;
      TrackpadFourFingerPinchGesture = 2;
      TrackpadFourFingerVertSwipeGesture = 2;
      TrackpadMomentumScroll = true;
      TrackpadPinch = true;
      TrackpadRotate = true;
      TrackpadThreeFingerHorizSwipeGesture = 2;
      TrackpadThreeFingerTapGesture = 0;
      TrackpadThreeFingerVertSwipeGesture = 2;
      TrackpadTwoFingerDoubleTapGesture = true;
      TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
    };
  };

  system.keyboard = {
    remapCapsLockToControl = false;
    enableKeyMapping = true;
    userKeyMapping = [
      {
        # Command → Globe
        HIDKeyboardModifierMappingSrc = 1095216660480; # 0xFF00000000 Left Command
        HIDKeyboardModifierMappingDst = 1095216660483; # 0xFF00000003 Globe
      }
      {
        # fn → Command
        HIDKeyboardModifierMappingSrc = 30064771202; # fn key HID usage
        HIDKeyboardModifierMappingDst = 1095216660480; # 0xFF00000000 Left Command
      }
    ];
  };
}
