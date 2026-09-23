{
  category = "Software";
  name = "obs";
  software = ["obs-studio"];

  homeManager = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
      obs-studio
    ];
  };
}
