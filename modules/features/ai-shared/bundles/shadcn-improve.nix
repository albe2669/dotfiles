{
  lib,
  pkgs,
  fetchFromGitHub,
  mkSkillsBundle,
}: let
  version = "03369ee6d7cafbfcecc4346539b05b3dc0a603bb";
in
  mkSkillsBundle {
    name = "shadcn-improve-skills";
    src = fetchFromGitHub {
      owner = "shadcn";
      repo = "improve";
      rev = version;
      sha256 = "sha256-m0a1n8xguDI2nooJ856sWPofh+tZI5VvIrVZrQH6XgY=";
    };
  }
