{
  fetchFromGitHub,
  mkSkillsBundle,
}: let
  version = "2ed6c52c9d7e5e56942508591085fd45dea277d3";
in
  mkSkillsBundle {
    name = "ponytail";
    src = fetchFromGitHub {
      owner = "DietrichGebert";
      repo = "ponytail";
      rev = version;
      sha256 = "sha256-bGdXvzhWPwGdz3T2Yh2h6lf+3PBRFAfdBxP5pESmCHI=";
    };
  }
