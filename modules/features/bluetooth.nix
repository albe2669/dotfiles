{config, ...}: {
  flake.modules.nixos.bluetooth = {...}: {
    hardware.bluetooth.enable = true;
    services.blueman.enable = false;
  };

  flake.modules.homeManager.bluetooth = {pkgs, ...}: {
    home.packages = with pkgs; [
      bluetuith
    ];
  };

  flake.modules.combined.bluetooth = {...}: {
    imports = [config.flake.modules.nixos.bluetooth];
    hm.imports = [config.flake.modules.homeManager.bluetooth];
  };
}
