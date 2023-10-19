{ pkgs, ... }:

let
  python-packages = ps: with ps; [
    numpy
    scipy
    scikit-learn
    scikit-image
    pandas
    matplotlib
    seaborn
    numba
    tqdm
    click
    qgrid
    torch
    torchvision
    opencv4
    imutils
    jupyterlab
    ipywidgets

    pypdf
    pdf2image
    pillow
  ];
in
{
  home.packages = [
    ((pkgs.python3.withPackages python-packages).override (args: { ignoreCollisions = true; }))
  ];
}
