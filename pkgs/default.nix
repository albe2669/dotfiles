{ pkgs, ...}:
{
  kitty = pkgs.callPackage ./kitty { };
  anytype = pkgs.callPackage ./anytype { };
  yuckls = pkgs.callPackage ./yuckls { };
}
