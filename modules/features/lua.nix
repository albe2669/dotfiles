{
  category = "Programming languages";
  name = "lua";
  software = [
    "lua"
    "lua-language-server"
  ];

  homeManager = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
      lua5_1
      lua51Packages.luarocks
      lua-language-server
    ];
  };
}
