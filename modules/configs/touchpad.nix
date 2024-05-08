{...}: {
  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
    tapping = true;
  };
}
