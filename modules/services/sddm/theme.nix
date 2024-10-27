# Alllllright future me.
# I am still 100% there is a way to split this into a builder file and then a file for each theme, but a the current moment it is completely beyond me.
# It's a mess in here and i want you to know i hate it as much as you probably do.
# I'm sorry.
# If you figure it out, please fix it. Otherwise increase this counter with your amount of hours spent.
# Hours spent: 3
{
  lib,
  pkgs,
  ...
}: let
  buildTheme = {
    # args
    name,
    version,
    src,
    themeConfig ? [],
    nativeBuildInputs ? [],
  }:
    pkgs.stdenv.mkDerivation rec {
      pname = "${name}";
      inherit version src nativeBuildInputs;

      buildCommand = ''
        installDir=$out/share/sddm/themes/${pname}

        mkdir -p $out/share/sddm/themes
        cp -aR $src $installDir

        ls -l $installDir
        chmod 644 $installDir/theme.conf
        ls -l $installDir
        ${lib.concatMapStringsSep "\n" (e: ''
            ${pkgs.crudini}/bin/crudini --set --inplace $installDir/theme.conf \
              "${e.section}" "${e.key}" "${e.value}"
          '')
          themeConfig}
      '';

      installPhase = ''
        chmod 444 $out/share/sddm/themes/${pname}/theme.conf
      '';
    };

  theme = themes.sugar-candy;
  themeName = theme.pkg.name;
  packages = [(buildTheme theme.pkg)] ++ theme.runtimeDeps;

  themes = {
    sugar-candy = {
      pkg = rec {
        name = "sddm-sugar-candy";
        version = "2b72ef6c6f720fe0ffde5ea5c7c48152e02f6c4f";

        src = pkgs.fetchFromGitLab {
          domain = "framagit.org";
          owner = "MarianArlt";
          repo = "${name}";
          rev = "${version}";
          sha256 = "sha256-XggFVsEXLYklrfy1ElkIp9fkTw4wvXbyVkaVCZq4ZLU=";
        };

        nativeBuildInputs = with pkgs.libsForQt5.qt5; [
          wrapQtAppsHook
        ];

        themeConfig = [
          {
            section = "General";
            key = "Background";
            value = "Backgrounds/green_hills.jpg";
          }
        ];
      };

      runtimeDeps = with pkgs.libsForQt5.qt5; [
        qtbase
        qtsvg
        qtquickcontrols2
        qtgraphicaleffects
      ];
    };
  };
in {
  environment.systemPackages = packages;

  services.displayManager.sddm.theme = themeName;
}
