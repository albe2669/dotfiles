{
  lib,
  pkgs,
  fetchFromGitHub,
  mkSkillsBundle,
}: let
  version = "ef85fa0c7ebb48bb59fe7593af5a67f3e02ff3d4";
in
  mkSkillsBundle {
    name = "herdr";
    src = fetchFromGitHub {
      owner = "ogulcancelik";
      repo = "herdr";
      rev = version;
      sha256 = "sha256-kVUyNs/C2bkUoVyr4ow+nyoXbFoc1/LvtYa/3ILRz9o=";
    };
    # SKILL.md lives at the repo root, not under skills/.
    skillsDirOverride = "";
  }
