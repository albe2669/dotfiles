{config, ...}: {
  flake.modules.nixos.touchpad = {...}: {
    services.libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        disableWhileTyping = true;
      };
    };
  };

  flake.modules.combined.touchpad = {...}: {
    imports = [config.flake.modules.nixos.touchpad];
  };
}
