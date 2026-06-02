{pkgs, ...}: {
  home.packages = let
    myPhp = pkgs.php83.buildEnv {
      extensions = {
        enabled,
        all,
      }:
        enabled
        ++ (with all; [
          xdebug
        ]);
      extraConfig = ''
        xdebug.mode=debug
        upload_max_filesize = 2G
        memory_limit = 2G
        max_execution_time = 120
      '';
    };
  in [
    myPhp
    pkgs.php83Packages.composer
  ];
}
