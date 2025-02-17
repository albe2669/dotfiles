{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    pulseaudio
    pavucontrol
  ];

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;

    configFile = pkgs.runCommand "default.pa" {} ''
      sed 's/module-udev-detect$/module-udev-detect tsched=0/' \
        ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
    '';
  };

  services.pipewire.enable = false;

  nixpkgs.config.pulseaudio = true;

  users.users.${username}.extraGroups = ["audio"];


}
