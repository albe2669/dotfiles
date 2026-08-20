_: {
  flake.modules.nixos.touchpad = _: {
    services.libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        disableWhileTyping = true;
      };
    };
  };
}
