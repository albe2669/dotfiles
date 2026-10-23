# azure-cli depends on python fabric, which supports invoke v3 only in an
# unreleased version. Backport NixOS/nixpkgs eeced2e (3.2.3-unstable-2026-04-07)
# until nixos-unstable ships it. Remove this overlay after the roll-up.
_final: prev: let
  fabricFixed = prev.python314Packages.fabric.overrideAttrs (old: {
    version = "3.2.3-unstable-2026-04-07";
    src = prev.fetchFromGitHub {
      owner = "fabric";
      repo = "fabric";
      rev = "cc098ad475dbbe2e10aba72692d83aee58919570";
      hash = "sha256-Z1tGcjdLrzbqcbS6XwapSgDNpyLbBiO21yeqi7XhbpQ=";
    };
    meta = builtins.removeAttrs old.meta ["broken"];
  });
  site = fabric: "${fabric}/lib/python3.14/site-packages";
in {
  azure-cli = prev.azure-cli.overrideAttrs (old: {
    propagatedBuildInputs =
      builtins.map (
        p:
          if (p.pname or null) == "fabric"
          then fabricFixed
          else p
      )
      old.propagatedBuildInputs;
    # old.postFixup wraps az with a PYTHONPATH that contains the broken
    # fabric's site-packages. Discard its string context — the broken fabric
    # would stay a build input otherwise. Every path in this string stays
    # in the closure through propagatedBuildInputs, which still references
    # fabricFixed.
    postFixup =
      builtins.replaceStrings [(site prev.python314Packages.fabric)] [(site fabricFixed)]
      (builtins.unsafeDiscardStringContext old.postFixup);
  });
}
