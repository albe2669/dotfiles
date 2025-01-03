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

      # Hacking
      dnspython

      # Excel
      openpyxl

      # LSP
      autopep8
      pycodestyle
    ];
in {
  home.packages = with pkgs-unstable; [
    poetry
    poppler_utils

    ((python3.withPackages python-packages).override (args: {ignoreCollisions = true;}))
  ];
}
