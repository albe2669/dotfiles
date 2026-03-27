{config}: let
  homePath = config.opts.variables.homeDirectory.path;
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
      ssh_private_key = {
        sopsFile = ./secrets/ssh.yaml;
        mode = "0600";
      };
      ssh_public_key = {
        sopsFile = ./secrets/ssh.yaml;
        mode = "0644";
      };
    };
  };
}
