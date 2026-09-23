{
  category = "Tools";
  name = "rune";

  homeManager = {
    self,
    system,
    config,
    lib,
    ...
  }: let
    helpers = import ../../../lib/helpers.nix;
    modelsData = import ../ai-shared/models.nix;

    chatModels = lib.filter (m: m.id != "corti-s1-embedding") modelsData.models;

    availableModels =
      lib.concatMapStrings (
        m: "      ${m.id}: ${toString m.contextWindow}\n"
      )
      chatModels;
  in {
    home.packages = [
      self.packages.${system}.rune
    ];

    home.file.".rune/config.yaml" = {
      source = helpers.mkDotfilesSymlink config "features/rune/config/config.yaml";
    };

    sops.templates."rune-models.yaml" = {
      content = ''
        models:
          custom:
            url: ${config.sops.placeholder.corti_base_url}
            api_key: ${config.sops.placeholder.corti_bearer}
            available_models:
          ${availableModels}
      '';
      path = "${config.home.homeDirectory}/.rune/config-models.yaml";
    };

    # Remove a legacy directory symlink at ~/.rune so home-manager can
    # create it as a real directory with individual file symlinks.
    home.activation.runeMigrate = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      if [ -L "$HOME/.rune" ]; then
        rm "$HOME/.rune"
      fi
    '';
  };
}
