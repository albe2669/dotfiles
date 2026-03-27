{ config, ... }: {
  flake.modules.homeManager.libreoffice = { pkgs, ... }: {
    home.packages = with pkgs; [
      libreoffice-qt
    ];
  };

  flake.modules.combined.libreoffice = { ... }: {
    hm.imports = [ config.flake.modules.homeManager.libreoffice ];
  };
}
