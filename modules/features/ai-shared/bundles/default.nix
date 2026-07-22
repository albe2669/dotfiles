{
  pkgs,
  mkSkillsBundle,
}: let
  inherit (pkgs) fetchFromGitHub;

  bundles = [
    (import ./herdr.nix {
      inherit
        fetchFromGitHub
        mkSkillsBundle
        ;
    })
    (import ./mattpocock.nix {
      inherit
        fetchFromGitHub
        mkSkillsBundle
        ;
    })
    (import ./shadcn-improve.nix {
      inherit
        fetchFromGitHub
        mkSkillsBundle
        ;
    })
  ];

  # Hand-written skills live alongside this file under ../skills/<name>/.
  custom = ../skills;
in
  pkgs.symlinkJoin {
    name = "ai-shared-skills";
    paths = bundles ++ [custom];
  }
