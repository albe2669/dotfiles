{pkgs, ...}: {
  kittykat = pkgs.callPackage ./kittykat {};
  # anytype = pkgs.callPackage ./anytype {};
  yuckls = pkgs.callPackage ./yuckls {};
  ccstatusline = pkgs.callPackage ./ccstatusline {};
  pup = pkgs.callPackage ./pup {};
}
