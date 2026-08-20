{
  isDarwin = system: builtins.match ".*-darwin" system != null;

  mkDotfilesSymlink = config: path:
    config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}/modules/${path}";
}
