{
  category = "System software";
  name = "tinycast";

  homeManager = {pkgs-unstable, ...}: {
    home.packages = [
      pkgs-unstable.tinycast
    ];
  };
}
