{
  category = "Programming languages";
  name = "javascript";
  software = ["nodejs_22"];

  homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      nodejs_22
      pnpm
      bun
    ];
  };
}
