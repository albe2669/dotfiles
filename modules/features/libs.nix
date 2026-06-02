{config, ...}: {
  flake.modules.nixos.libs = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      libnotify
    ];
  };

  flake.modules.combined.libs = {...}: {
    imports = [config.flake.modules.nixos.libs];
  };
}
