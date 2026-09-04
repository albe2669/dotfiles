{
  fetchFromGitHub,
  mkSkillsBundle,
}: let
  version = "3c2629142c5d437428269b1b722b08c0b87f574d";
in
  mkSkillsBundle {
    name = "humanlayer-skills";
    src = fetchFromGitHub {
      owner = "humanlayer";
      repo = "skills";
      rev = version;
      sha256 = "sha256-lJvu9CGAN/+dzmzck0CodRXn/p7GUkCbfyZxys4nIoU=";
    };
    skillsDirOverride = "plugins";
    skillsSubDir = "skills";
    categories = [
      "build-iterated-agentic-loop"
      "design-control-loop"
      "improve-claude-md"
      "show-me"
    ];
  }
