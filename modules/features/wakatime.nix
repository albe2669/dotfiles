{config, ...}: {
  flake.modules.homeManager.wakatime = {
    pkgs,
    config,
    ...
  }: let
    format = pkgs.formats.ini {};
    secrets = config.sops.secrets;
  in {
    home.file.".wakatime.cfg".source = format.generate ".wakatime.cfg" {
      settings =
        {
          debug = false;
          hidefilenames = false;
          ignore = "
            \tCOMMIT_EDITMSG$
            \tPULLREQ_EDITMSG$
            \tMERGE_MSG$
            \tTAG_EDITMSG$
          ";
        }
        // (
          if secrets ? wakatime_api_key.path
          then {api_key_vault_cmd = "cat ${secrets.wakatime_api_key.path}";}
          else {api_key = "placeholder";}
        );
    };
    home.file.".wakatime.cfg".force = true;
  };

  flake.modules.combined.wakatime = {...}: {
    hm.imports = [config.flake.modules.homeManager.wakatime];
  };
}
