{
  category = "Software";
  name = "yaak";

  homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      yaak
    ];
  };
}
