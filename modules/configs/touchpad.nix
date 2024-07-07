{...}: {
  services.xserver.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
    tapping = true;
  };
}
