{zen-browser, system, ...}: {
  home.packages = [
    zen-browser.packages."${system}".default
  ];
}
