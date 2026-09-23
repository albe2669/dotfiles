{
  category = "Programming languages";
  name = "tex";
  software = ["texlab"];

  homeManager = {pkgs-unstable, ...}: let
    tex = pkgs-unstable.texlive.combine {
      inherit
        (pkgs-unstable.texlive)
        scheme-medium
        tufte-latex
        hardwrap
        catchfile
        titlesec
        adjustbox
        enumitem
        gauss
        forest
        standalone
        ncctools
        lastpage
        tikzpagenodes
        ifoddpage
        doi
        ;
    };
  in {
    home.packages = with pkgs-unstable; [
      texlab
      tex
    ];
  };
}
