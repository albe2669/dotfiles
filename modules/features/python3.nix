{
  category = "Programming languages";
  name = "python3";
  software = [
    "uv"
    "poppler-utils"
    "python3"
    "basedpyright"
    "ruff"
  ];

  homeManager = {pkgs-unstable, ...}: let
    python-packages = ps:
      with ps; [
        build
        wheel
        pypdf
        pdf2image
        pillow
        mysql-connector
        pytest
        dbus-python
        openpyxl
        autopep8
        pycodestyle
        pandas
        numpy
      ];
  in {
    home.packages = with pkgs-unstable; [
      uv
      poppler-utils
      basedpyright
      ruff
      virtualenv
      ((python3.withPackages python-packages).override (_args: {
        ignoreCollisions = true;
      }))
    ];

    opts = {
      editor.lsp.servers = {
        basedpyright.enable = true;
        ruff.enable = true;
      };
      tsGrammars = [
        pkgs-unstable.vimPlugins.nvim-treesitter.builtGrammars.tree-sitter-python
      ];
    };
  };
}
