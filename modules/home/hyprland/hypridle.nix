{
  lib,
	config,
	pkgs,
	...
}: {
  services.hypridle = {
    enable = true;

	  settings = let
		  timeout = 300;
			loginctl = "${lib.getExe' pkgs.systemd "loginctl"}";
			hyprlock = "${lib.getExe config.programs.hyprlock.package}";
			brightnessctl = "${lib.getExe pkgs.brightnessctl}";
			hyprctl = "${lib.getExe' pkgs.hyprland "hyprctl"}";
		in {
		  general = {
			  lock_cmd = "pidof ${hyprlock} || ${hyprlock}";
				before_sleep_cmd = "${loginctl} lock-session";
				after_sleep_cmd = "${hyprctl} dispatch dpms on";
			};

			listener = [
			  {
				  timeout = timeout/ 2;
					on-timeout = "${brightnessctl} -s set 10";
					on-resume =  "${brightnessctl} -r"; 
				}

				{
				  timeout = timeout;
					on-timeout = "${loginctl} lock-session";
				}

				{
				  timeout = timeout + 30;
				  on-timeout = "${hyprctl} dispatch dpms off";
					on-resume = "${hyprctl} dispatch dpms on && ${brightnessctl} -r";
				}

				{
				  timeout = timeout + 60;
					on-timeout = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
				}
			];
		};
	};

  systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
}
