{
  category = "Programming languages";
  name = "advent-of-code";

  homeManager = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [];
  };
}
