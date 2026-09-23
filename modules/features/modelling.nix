{
  category = "Software";
  name = "modelling";
  software = ["freecad"];

  homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      freecad
    ];
  };
}
