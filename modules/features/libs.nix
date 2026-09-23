{
  category = "System software";
  name = "libs";
  software = ["libnotify"];

  nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      libnotify
    ];
  };
}
