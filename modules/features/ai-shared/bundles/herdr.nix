{
  fetchFromGitHub,
  mkSkillsBundle,
}: let
  version = "51b7064ef0a02642393bab1d2eea0f4dbd8414d2";
in
  mkSkillsBundle {
    name = "herdr";
    src = fetchFromGitHub {
      owner = "ogulcancelik";
      repo = "herdr";
      rev = version;
      sha256 = "sha256-ALhahxbdgnN8rMvlKmgB5py0etICwyYY75Uz0jLIpM4=";
    };
  }
