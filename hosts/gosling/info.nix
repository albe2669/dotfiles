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
      default = "gosling";
      description = "System name";
    };

    diskPath = lib.mkOption {
      type = lib.types.path;
      default = "/dev/nvme0n1";
      description = "Path to the disk used for installation";
    };
  };

  imports = [
    (import ./disko.nix {diskPath = cfg.diskPath;})
  ];

  config = {
  };
}
