{ pkgs, ... }:

let 
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-medium
      tufte-latex hardwrap catchfile titlesec adjustbox enumitem;
  });
in {
  home.packages = with pkgs; [
    tex
  ];
}
