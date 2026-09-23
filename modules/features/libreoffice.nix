{
  category = "Software";
  name = "libreoffice";
  software = ["libreoffice-qt"];

  homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      libreoffice-qt
    ];
  };
}
