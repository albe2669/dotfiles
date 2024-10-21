{pkgs, ...}: {
  home.packages = let
    myPhp = pkgs.php83.buildEnv {extraConfig = "upload_max_filesize = 2G";};
  in [
    myPhp
    pkgs.php83Packages.composer
  ];
}
