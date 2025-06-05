{
  zen-browser,
  system,
  config,
  ...
}: {
  home.packages = [
    (config.lib.nixGL.wrapOffload zen-browser.packages."${system}".default)
  ];
}
