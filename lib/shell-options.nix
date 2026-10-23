{lib, ...}: {
  options.shell = {
    envVars = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Environment variables to set in the shell. On systems with the shell module, these are also pushed live into fish universal variables and launchctl during activation, so running shells and newly launched GUI applications see updates without a logout.";
    };

    paths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Paths to add to PATH";
    };

    aliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Shell aliases";
    };

    abbreviations = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Shell abbreviations (fish-specific, mapped to aliases in other shells)";
    };

    initExtra = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra shell initialization code";
    };

    completions = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            fish = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = "Fish completion code";
            };
            zsh = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = "Zsh completion code";
            };
          };
        }
      );
      default = {};
      description = "Shell completions per shell";
    };
  };
}
