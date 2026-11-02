{pkgs, ...}: {
  kittykat = pkgs.callPackage ./kittykat {};
  # anytype = pkgs.callPackage ./anytype {};
  vls = pkgs.callPackage ./vls {};
  ccstatusline = pkgs.callPackage ./ccstatusline {};
  rune = pkgs.callPackage ./rune {};
}
