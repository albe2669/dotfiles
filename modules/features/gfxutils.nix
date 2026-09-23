{
  category = "Tools";
  name = "gfxutils";
  software = ["mesa-demos"];

  homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      mesa-demos # Renamed from glxinfo
    ];
  };
}
