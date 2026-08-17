{config, ...}: {
  flake.modules.homeManager.cliamp = {
    pkgs-unstable,
    config,
    ...
  }: let
    apiKeyEnvName = "SPOTIFY_CLIENT_ID";
    pkg = pkgs-unstable.cliamp.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs-unstable.makeWrapper];

      postFixup = ''
        wrapProgram $out/bin/cliamp \
          --run 'export ${apiKeyEnvName}=$(cat ${config.sops.secrets.spotify_client_id.path})'
      '';
    });

    toml = pkgs-unstable.formats.toml {};
  in {
    home.packages = [
      pkg
    ];

    xdg.configFile."cliamp/config.toml".source = toml.generate "cliamp-config" {
      spotify = {
        client_id = "\$\{${apiKeyEnvName}\}";
      };
    };
  };

  flake.modules.combined.cliamp = _: {
    hm.imports = [config.flake.modules.homeManager.cliamp];
  };
}
