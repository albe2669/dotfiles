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
      default = "larry";
      description = "System name";
    };

    diskPath = lib.mkOption {
      type = lib.types.path;
      default = "/dev/disk/by-id/skhynix_SSD_1234567890ABCDEF";
      description = "Path to the disk used for installation";
    };
  };

  imports = [
    (import ./disko.nix {diskPath = cfg.diskPath;})
  ];

  config = {
  };
}
