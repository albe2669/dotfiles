{
  fetchFromGitHub,
  buildDotnetModule,
  dotnet-sdk,
}:
let
  dotnet_8 = dotnet-sdk;
in

buildDotnetModule {
  pname = "yuckls";
  version = "";

  src = fetchFromGitHub {
    owner = "Eugenenoble2005";
    repo = "YuckLS";
    rev = "ab4c0315cd6c77ef0ed3c620bde0ece48e4a5949";
    hash = "sha256-HhxFVX9BHNydguGFZMd5FNZB06KxF34A9CqTzwJijes=";
  };

  projectFile = "YuckLS/YuckLS.csproj";

  dotnet-sdk = dotnet_8;
  nugetDeps = ./deps.nix;
}
