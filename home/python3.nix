{pkgs, ...}: let
  python-packages = ps:
    with ps; [
      # Machine learning packages
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

      # ml-slide-splitter
      pypdf
      pdf2image
      pillow

      # Database
      mysql-connector

      # Testing
      pytest
      autopep8
      pycodestyle
    ];
in {
  home.packages = [
    ((pkgs.python3.withPackages python-packages).override (args: {ignoreCollisions = true;}))
  ];
}