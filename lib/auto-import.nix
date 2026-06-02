# Auto-import utility for the dendritic module pattern.
# Returns a list of module paths from a directory.
# Imports:
#   - Direct .nix files (excluding default.nix and _-prefixed)
#   - Subdirectories containing a default.nix (excluding _-prefixed)
lib: dir: let
  entries = builtins.readDir dir;

  nixFiles = builtins.filter (name: let
    type = entries.${name};
  in
    type
    == "regular"
    && lib.hasSuffix ".nix" name
    && name != "default.nix"
    && !lib.hasPrefix "_" name)
  (builtins.attrNames entries);

  subDirs = builtins.filter (name: let
    type = entries.${name};
  in
    type
    == "directory"
    && !lib.hasPrefix "_" name
    && builtins.pathExists (dir + "/${name}/default.nix"))
  (builtins.attrNames entries);
in
  (map (name: dir + "/${name}") nixFiles)
  ++ (map (name: dir + "/${name}") subDirs)
