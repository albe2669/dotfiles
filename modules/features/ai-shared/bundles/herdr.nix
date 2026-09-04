{
  fetchFromGitHub,
  mkSkillsBundle,
}: let
  version = "3150bd92d6162ba248bc28fd4d40bd0d6238e1af";
in
  mkSkillsBundle {
    name = "herdr";
    src = fetchFromGitHub {
      owner = "ogulcancelik";
      repo = "herdr";
      rev = version;
      sha256 = "sha256-tMOvyjh+JAD6lnkghaGE78URt26bQuSAkkiSaLBiQdY=";
    };
  }
