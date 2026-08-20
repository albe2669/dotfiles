_: {
  flake.modules.nixos.libs = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      libnotify
    ];
  };
}
