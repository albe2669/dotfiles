{
  category = "System software";
  name = "tinycast";

  homeManager = {pkgs, ...}: {
    home.packages = [
      pkgs.tinycast
    ];
  };
}
