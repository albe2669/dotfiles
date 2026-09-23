{
  category = "Programming languages";
  name = "nodejs";
  software = ["nodejs_22"];

  homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      nodejs_22
    ];
  };
}
