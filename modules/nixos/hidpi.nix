{
  config,
  lib,
  ...
}:
with config.opts; {
  config = lib.mkIf variables.isHidpi {
    services = {
      xserver.dpi = variables.screen.dpi;

      displayManager.sddm.enableHidpi = true;
    };

    environment.variables = {
      GDK_SCALE = "${toString variables.screen.scaleFactor}";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    };
  };
}
