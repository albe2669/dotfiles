{pkgs, ...}: {
  home.packages = let
    myPhp = pkgs.php83.buildEnv {
      extensions = ({ enabled, all }: enabled ++ (with all; [
          xdebug
      ]));
      extraConfig = ''
        xdebug.mode=debug
        upload_max_filesize = 2G
      '';
    };
  in [
    myPhp
    pkgs.php83Packages.composer
  ];
}
