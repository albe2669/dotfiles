{pkgs, ...}: let
  inherit (pkgs) fetchurl;
  insomnia = pkgs.insomnia.overrideAttrs (oldAttrs: rec {
    inherit (oldAttrs) pname meta;

    version = "8.6.1";
    src = fetchurl {
      url = "https://github.com/Kong/insomnia/releases/download/core%40${version}/Insomnia.Core-${version}.deb";
      sha256 = "sha256-qy2j6kdmtDgfTab8gTz7eb/uNKwtzbxcoJHNibVa35c=";
    };
  });
in {
  home.packages = [
    insomnia
  ];
}
