{
  inputs,
  self,
  config,
  ...
}:
let
  system = "x86_64-linux";

  # Same package-set construction as modules/home-manager-wiring.nix:
  # single instantiation, fabric allowed to be broken.
  pkgs = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
    config.problems.handlers.fabric.broken = "warn";
    overlays = import ../overlays { inherit inputs; };
  };

  # homeManager halves of the features this standalone host uses, straight
  # from the flake-level registry built in modules/default.nix.
  hm = config.flake.modules.homeManager;

  # Stylix is only exposed as nixos/darwin modules in its feature; on a
  # standalone host apply the same palette through the HM module.
  stylixSettings = {
    enable = true;
    autoEnable = false;
    base16Scheme = ../modules/features/stylix/everforest-dark-hard.yaml;
    polarity = "dark";
    image = ../modules/features/wallpapers/images/misty_forest.jpg;
    opacity = {
      terminal = 0.85;
      popups = 0.8;
    };
    fonts = {
      sizes.terminal = 11;
      sansSerif = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };
      monospace = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font Mono";
      };
    };
  };
in
{
  flake.homeConfigurations.puffin = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    extraSpecialArgs = {
      inherit inputs self;
      inherit (pkgs) system;
      pkgs-unstable = pkgs;
      username = "arn";
    };

    modules = [
      ../variables.nix
      ../theme.nix

      inputs.sops-nix.homeManagerModules.sops
      inputs.nixvim.homeModules.nixvim
      inputs.stylix.homeModules.stylix
      ({ ... }: {
        _module.args.pkgs-unstable = pkgs;
        stylix = stylixSettings;
      })
      {
        # Intentionally on unstable nixpkgs while HM tracks stable.
        home.enableNixpkgsReleaseCheck = false;

        opts.variables = {
          username = "arn";
          isDarwin = false;
        };

        # The Ubuntu VM user is `arn`, not the default `goose`.
        home.username = "arn";
        home.homeDirectory = "/home/arn";
      }
    ]
    ++ (with hm; [
      # Requested modules
      omp
      sops
      go
      fish
      git
      nvim
      azure-cli
      k8
      worktree
      ai

      # Supporting modules pulled in by the ones above
      home
      xdg
      shell
      utils
      direnv
      lazygit
      lazydocker
      yazi
      herdr
      wakatime
    ]);
  };
}
