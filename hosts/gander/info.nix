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
      default = "gander";
      description = "System name";
    };

    diskPath = lib.mkOption {
      type = lib.types.path;
      default = "/dev/disk/by-id/ata-KINGSTON_SA400S37480G_50026B7682B1C6A7";
      description = "Path to the disk used for installation";
    };
  };

  imports = [
    (import ./disko.nix {diskPath = cfg.diskPath;})
  ];

  config = {
  };
}
