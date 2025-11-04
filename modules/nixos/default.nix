{
  core-server = ./core-server.nix;
  core-desktop = ./core-desktop.nix;
  core-laptop = ./core-laptop.nix;

  home = ./home.nix;

  battery = ./battery.nix;
  bootloader = ./bootloader.nix;
  bootloader-uefi = ./bootloader-uefi.nix;
  libs = ./libs.nix;
  network = ./network.nix;
  nix = ./nix.nix;
  nvidia-prime = ./nvidia-prime.nix;
  nvidia = ./nvidia.nix;
  state = ./state.nix;
  storage = ./storage.nix;
  stylix = ./stylix;
  bluetooth = ./bluetooth.nix;
  docker = ./docker.nix;
  pipewire = ./pipewire.nix;
  power = ./power.nix;
  printing = ./printing.nix;
  qemu = ./qemu.nix;
  sddm = ./sddm;
  security = ./security.nix;
  shell = ./shell.nix;
  tailscale = ./tailscale.nix;
  virtualbox = ./virtualbox.nix;
  wireless = ./wireless.nix;
  xdg = ./xdg.nix;
  dynamic-libs = ./dynamic-libs.nix;
  font-packages = ./font-packages.nix;
  fonts = ./fonts.nix;
  hidpi = ./hidpi.nix;
  hyprland = ./hyprland.nix;
  i3 = ./i3.nix;
  programs = ./programs.nix;
  system-packages = ./system-packages.nix;
  touchpad = ./touchpad.nix;
  user-groups = ./user-groups.nix;
}
