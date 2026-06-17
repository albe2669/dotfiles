{pkgs, ...}: {
  kittykat = pkgs.callPackage ./kittykat {};
  # anytype = pkgs.callPackage ./anytype {};
  yuckls = pkgs.callPackage ./yuckls {};
  ccusage = pkgs.callPackage ./ccusage {};
  ccstatusline = pkgs.callPackage ./ccstatusline {};
  pup = pkgs.callPackage ./pup {};
  omp = pkgs.callPackage ./omp {};
}
