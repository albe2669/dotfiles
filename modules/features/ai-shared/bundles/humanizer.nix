{
  fetchFromGitHub,
  mkSkillsBundle,
}: let
  version = "9862685f575c65a8247f90369951df1b3416e3d6";
in
  mkSkillsBundle {
    name = "ponytail";
    src = fetchFromGitHub {
      owner = "blader";
      repo = "humanizer";
      rev = version;
      sha256 = "sha256-tC7vHxHDzTRgpsF7i6YnKWhAbrkeclspRJVK1osRE24=";
    };
    skillsDirOverride = "";
  }
