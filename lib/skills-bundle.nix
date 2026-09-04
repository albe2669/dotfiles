# Build a flat skills directory from an agent skills repo.
#
#   categorized: skills/<category>/<name>/SKILL.md  (e.g. mattpocock/skills)
#   flat:         skills/<name>/SKILL.md            (e.g. shadcn/improve)
#   root-level:   SKILL.md at the skills-dir root   (e.g. ogulcancelik/herdr)
#
# Flattened output: <name>/SKILL.md (+ optional sibling files).
lib: pkgs: {
  name,
  src,
  categories ? null,
  exclude ? [],
  skillsDirOverride ? null,
  skillsSubDir ? null,
}: let
  skillsDir =
    if skillsDirOverride != null
    then "${src}/${skillsDirOverride}"
    else "${src}/skills";

  # A skill dir is a directory that directly contains a SKILL.md.
  isSkillDir = dir: builtins.pathExists dir && (builtins.readDir dir ? "SKILL.md");

  # readDir filtered to subdirectories only.
  subDirs = dir:
    if builtins.pathExists dir
    then lib.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir dir))
    else [];

  # Categorized layout: iterate selected categories, link each skill dir.
  linkCategory = cat: let
    catDir =
      if skillsSubDir != null
      then "${skillsDir}/${cat}/${skillsSubDir}"
      else "${skillsDir}/${cat}";
    linkSkill = skill:
      if skill == "deprecated" || builtins.elem skill exclude
      then ""
      else "ln -s ${catDir}/${skill} $out/${skill}";
  in
    lib.concatMapStringsSep "\n" linkSkill (subDirs catDir);

  # Flat layout: link every skill dir directly under skills/.
  linkFlat = let
    linkSkill = skill:
      if builtins.elem skill exclude
      then ""
      else "ln -s ${skillsDir}/${skill} $out/${skill}";
  in
    lib.concatMapStringsSep "\n" linkSkill (subDirs skillsDir);

  # Auto-detect layout when `categories` is null:
  #   root-level   — the skills dir itself contains SKILL.md (e.g. ogulcancelik/herdr).
  #   flat         — at least one top-level entry under skills/ is a skill dir
  #                  (contains SKILL.md directly, e.g. shadcn/improve).
  #   categorized — no top-level entry is a skill dir, so top-level dirs are
  #                  categories; link every skill under every category
  #                  (e.g. a repo with engineering/ + productivity/ + misc/).
  topEntries = subDirs skillsDir;
  isRootLevel = isSkillDir skillsDir;
  isFlat = lib.any isSkillDir (map (n: "${skillsDir}/${n}") topEntries);
  commands =
    if categories != null
    then lib.concatMapStringsSep "\n" linkCategory categories
    else if isRootLevel
    then ''
      mkdir $out/${name}
      ln -s ${skillsDir}/SKILL.md $out/${name}/SKILL.md''
    else if isFlat
    then linkFlat
    else lib.concatMapStringsSep "\n" linkCategory topEntries;
in
  pkgs.runCommand name {} ''
    mkdir -p $out
    ${commands}
  ''
