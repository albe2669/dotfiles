{ pkgs, ... }:

let
  inherit (pkgs) fetchurl;
  obsidian = pkgs.obsidian.overrideAttrs (oldAttrs: rec {
    inherit (oldAttrs) pname meta icon desktopItem;

    version = "1.3.7";
    filename = "obsidian-${version}.tar.gz";
    src = fetchurl {
      url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/${filename}";
      sha256 = "sha256-8Qi12d4oZ2R6INYZH/qNUBDexft53uy9Uug7UoArwYw=";
    };
  });
in
{
  home.packages = [
    obsidian
  ];
}
