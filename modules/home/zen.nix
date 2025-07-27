{
  inputs,
  system,
  config,
  ...
}: {
  home.packages = [
    (config.lib.nixGL.wrapOffload inputs.zen-browser.packages."${system}".default)
  ];
}
