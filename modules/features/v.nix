{
  category = "Programming languages";
  name = "v";
  software = [
    "v"
  ];

  homeManager = {pkgs-unstable, ...}: {
    home.packages = [
      pkgs-unstable.vlang
    ];

    opts.editor.lsp.servers.vls = {
      enable = true;
      package = pkgs-unstable.vlang;
    };
  };
}
