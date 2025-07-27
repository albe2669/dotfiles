{
  lib,
  config,
  ...
}: let
  cfg = config.opts.info;
in {
  options.opts.info = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "skein";
      description = "System name";
    };

    diskPath = lib.mkOption {
      type = lib.types.path;
      default = "/dev/sda";
      description = "Path to the disk used for installation";
    };
  };

  imports = [
    (import ./disko.nix {diskPath = cfg.diskPath;})
  ];

  config = {
  };

  config.opts.variables.isHidpi = true;
}
