{
  lib,
  pkgs,
  mkSkillsBundle,
}: let
  fetchFromGitHub = pkgs.fetchFromGitHub;

  bundles = [
    (import ./mattpocock.nix {
      inherit
        lib
        pkgs
        fetchFromGitHub
        mkSkillsBundle
        ;
    })
    (import ./shadcn-improve.nix {
      inherit
        lib
        pkgs
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
