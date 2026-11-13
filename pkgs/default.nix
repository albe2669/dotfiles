{pkgs, ...}: {
  kittykat = pkgs.callPackage ./kittykat {};
  # anytype = pkgs.callPackage ./anytype {};
  ccstatusline = pkgs.callPackage ./ccstatusline {};
  rune = pkgs.callPackage ./rune {};
}
