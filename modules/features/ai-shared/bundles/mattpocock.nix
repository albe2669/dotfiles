{
  fetchFromGitHub,
  mkSkillsBundle,
}: let
  version = "3cca18b368ae95cdbdebbff572ccafa662551015";
in
  mkSkillsBundle {
    name = "mattpocock-skills";
    src = fetchFromGitHub {
      owner = "mattpocock";
      repo = "skills";
      rev = version;
      sha256 = "sha256-dF5i37jHnqfcXD1IRSVzSSm/pfCYSUmOsEhhs5Zx340=";
    };
    # Curated set matches the repo's .claude-plugin/plugin.json manifest:
    # engineering + productivity only. in-progress/misc/personal are excluded.
    categories = [
      "engineering"
      "productivity"
    ];
  }
