{
  lib,
  pkgs,
  fetchFromGitHub,
  mkSkillsBundle,
}: let
  version = "9603c1cc8118d08bc1b3bf34cf714f62178dea3b";
in
  mkSkillsBundle {
    name = "mattpocock-skills";
    src = fetchFromGitHub {
      owner = "mattpocock";
      repo = "skills";
      rev = version;
      sha256 = "sha256-S6pARK99oGGSi6XdFm6zYKHT4gjOCN0wIPZFcl1hREE=";
    };
    # Curated set matches the repo's .claude-plugin/plugin.json manifest:
    # engineering + productivity only. in-progress/misc/personal are excluded.
    categories = [
      "engineering"
      "productivity"
    ];
  }
