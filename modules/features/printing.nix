{config, ...}: {
  flake.modules.nixos.printing = {pkgs, ...}: {
    services.avahi = {
      enable = false;
    };

    services.printing = {
      enable = true;
      drivers = with pkgs; [
        hplip
        gutenprint
        foo2zjs
        epson-escpr2
      ];
      openFirewall = false;
    };
  };

  flake.modules.combined.printing = {...}: {
    imports = [config.flake.modules.nixos.printing];
  };
}
