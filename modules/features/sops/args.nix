{config}: let
  homePath = config.opts.variables.homeDirectory.path;
  cortiConfig = {
    sopsFile = ./secrets/corti.yaml;
  };
in {
  sharedArgs = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.keyFile = "${homePath}/.config/sops/age/keys.txt";

    secrets = {
      wakatime_api_key = {
        sopsFile = ./secrets/wakatime.yaml;
      };
      git_credentials = {
        sopsFile = ./secrets/git_credentials.yaml;
      };
      gh_token = {
        sopsFile = ./secrets/git_credentials.yaml;
      };
      ssh_private_key = {
        sopsFile = ./secrets/ssh.yaml;
        mode = "0600";
      };
      ssh_public_key = {
        sopsFile = ./secrets/ssh.yaml;
        mode = "0644";
      };
      corti_client_id = cortiConfig;
      corti_client_secret = cortiConfig;
      corti_tenant = cortiConfig;
      corti_bearer = cortiConfig;
      corti_base_url = cortiConfig;
    };
  };
}
