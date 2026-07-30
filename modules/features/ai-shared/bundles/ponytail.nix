{
  fetchFromGitHub,
  mkSkillsBundle,
}: let
  version = "16f29800fd2681bdf24f3eb4ccffe38be3baec6b";
in
  mkSkillsBundle {
    name = "ponytail";
    src = fetchFromGitHub {
      owner = "DietrichGebert";
      repo = "ponytail";
      rev = version;
      sha256 = "sha256-Y7d4s7uqjH6IbEXhqAiQ+yaxr6iiGcv2X64LuMtG1T8=";
    };
  }
