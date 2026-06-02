{lib, ...}: {
  system.defaults = {
    dock = {
      expose-animation-duration = lib.mkDefault 0.0;
    };

    NSGlobalDomain = {
      NSAutomaticWindowAnimationsEnabled = lib.mkDefault false;
    };

    spaces.spans-displays = lib.mkDefault true;

    CustomUserPreferences = {
      NSGlobalDomain.NSWindowShouldDragOnGesture = true;
    };
  };
}
