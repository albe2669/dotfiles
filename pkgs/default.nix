{pkgs, ...}: {
  kittykat = pkgs.callPackage ./kittykat {};
  # anytype = pkgs.callPackage ./anytype {};
  yuckls = pkgs.callPackage ./yuckls {};
  rtk = pkgs.callPackage ./rtk {};
  ccusage = pkgs.callPackage ./ccusage {};
}
