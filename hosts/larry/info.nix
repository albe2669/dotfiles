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
  };

  config = {
  };
}
