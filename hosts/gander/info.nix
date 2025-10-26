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
      default = "/dev/disk/by-id/nvme-WD_Blue_SN5000_500GB_25320W805731";
      description = "Path to the disk used for installation";
    };
  };

  imports = [
    (import ./disko.nix {diskPath = cfg.diskPath;})
  ];

  config = {
  };
}
