{
  pkgs,
  variables,
  ...
}: {
  imports = [
    # Also included by default in core-server
    ./services/power.nix
    ./services/tlp.nix
  ];

  services = {
    acpid.enable = true;

    # TODO: This might horribly break if you ever switch to an AMD CPU
    thermald.enable = true;

    logind.extraConfig = ''
      HoldoffTimeoutSec=0
    '';
  };

  systemd.services.battery_check = {
    description = "Send notification if battery is low";
    serviceConfig = {
      Type = "oneshot";
      User = variables.username;
      ExecStart = pkgs.writeScript "battery_check" ''
        #!${pkgs.bash}/bin/bash
        . <(udevadm info -q property -p /sys/class/power_supply/BAT0 | grep -E 'POWER_SUPPLY_(CAPACITY|STATUS)=')
        if [[ $POWER_SUPPLY_STATUS = Discharging && $POWER_SUPPLY_CAPACITY -lt 15 ]];
        then 
          ${pkgs.libnotify}/bin/notify-send -u critical "Battery is low" "Battery is low: $POWER_SUPPLY_CAPACITY"
        fi
      '';
    };
    environment = {
      DISPLAY = ":0";
      DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
    };
    after = ["display-manager.service"];
    startAt = "*:00/5"; # Every 5 minutes
  };
}
