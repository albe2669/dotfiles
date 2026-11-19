{pkgs, ...}: {
  kittykat = pkgs.callPackage ./kittykat {};
  kotlin-lsp = pkgs.callPackage ./kotlin-lsp {};
  # anytype = pkgs.callPackage ./anytype {};
  ccstatusline = pkgs.callPackage ./ccstatusline {};
  rune = pkgs.callPackage ./rune {};
}
