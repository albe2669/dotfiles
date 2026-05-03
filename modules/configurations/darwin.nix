{config, ...}: {
  flake.modules.combined.darwin-core = {...}: {
    imports = with config.flake.modules.combined; [
      nix-settings
      state
      system-packages
      system-settings
      user
      homebrew
    ];

    security.pam.services.sudo_local.touchIdAuth = true;
    documentation = {
      enable = false;
      man.enable = false;
      info.enable = false;
    };

    hm.imports = [
      {programs.man.enable = false;}
    ];
  };
}
