{
  fetchFromGitHub,
  mkSkillsBundle,
}: let
  version = "9c9f36ccd3995266cd675468af71639c8dde1ec5";
in
  mkSkillsBundle {
    name = "mattpocock-skills";
    src = fetchFromGitHub {
      owner = "mattpocock";
      repo = "skills";
      rev = version;
      sha256 = "sha256-CJNC5fORkc+FGd+FlCXG6rZcVv2MCqCNHCVC0AW623Q=";
    };
    # Curated set matches the repo's .claude-plugin/plugin.json manifest:
    # engineering + productivity only. in-progress/misc/personal are excluded.
    categories = [
      "engineering"
      "productivity"
    ];
  }
