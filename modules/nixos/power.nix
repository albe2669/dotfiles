{pkgs,...}: {
  environment.systemPackages = with pkgs; [
    powertop
  ];

  powerManagement = {
    enable = true;
    # powertop.enable = true;
  };
}
