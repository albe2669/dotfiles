{
  category = "Tools";
  name = "opencode";

  homeManager = {
    inputs,
    system,
    config,
    ...
  }: let
    helpers = import ../../../lib/helpers.nix;
  in {
    home.packages = [
      inputs.llm-agents.packages.${system}.opencode2
    ];

    xdg.configFile.opencode = {
      source = helpers.mkDotfilesSymlink config "features/opencode/config";
    };
  };
}
