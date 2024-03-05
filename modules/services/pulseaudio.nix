{pkgs, username, ...}: {
  environment.systemPackages = with pkgs; [
    pulseaudio
  ];

  hardware.pulseaudio = { 
    enable = true;
    support32Bit = true;
  };

  users.users.${username}.extraGroups = [ "audio" ];
}
