{pkgs-unstable, ...}: let
  python-packages = ps:
    with ps; [
      # Common
      build
      wheel

      # ml-slide-splitter
      pypdf
      pdf2image
      pillow

      # Database
      mysql-connector

      # Testing
      pytest

      # eduroam
      dbus-python

      # Excel
      openpyxl

      # LSP
      autopep8
      pycodestyle

      pandas
      numpy
    ];
in {
  home.packages = with pkgs-unstable; [
    uv
    poppler_utils

    ((python3.withPackages python-packages).override (args: {ignoreCollisions = true;}))
  ];
}
