{
  category = "Programming languages";
  name = "advent-of-code";
  software = [
    "aoc-cli"
  ];

  homeManager = {
    config,
    pkgs-unstable,
    ...
  }: {
    home.packages = with pkgs-unstable; [
      aoc-cli
    ];

    sops.templates."adventofcode.session" = {
      content = "${config.sops.placeholder.aoc_session}";
      path = "${config.xdg.configHome}/adventofcode.session";
    };
  };
}
