{
  fetchFromGitHub,
  mkSkillsBundle,
}: let
  version = "3027f20f3181758385a1bb8c022d4041dfb4de84";
in
  mkSkillsBundle {
    name = "agent-toolkit";
    src = fetchFromGitHub {
      owner = "softaworks";
      repo = "agent-toolkit";
      rev = version;
      sha256 = "sha256-1q4IP55kvZhJibTLJct0SSifw46lBmAQhp9nSmDzYxs=";
    };
  }
