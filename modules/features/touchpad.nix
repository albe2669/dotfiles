{
  category = "System software";
  name = "touchpad";

  nixos = _: {
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
