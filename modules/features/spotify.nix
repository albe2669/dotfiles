{
  config,
  inputs,
  ...
}: {
  flake.modules.homeManager.spotify = {
    inputs,
    system,
    pkgs-unstable,
    ...
  }: {
    imports = [
      inputs.spicetify-nix.homeManagerModules.default
    ];

    stylix.targets = {
      spicetify.enable = true;
      spotify-player.enable = true;
    };

    programs.spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
    in {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        # keyboardShortcut
        # powerBar
        fullAlbumDate
        # goToSong
        listPlaylistsWithSong
        wikify
        showQueueDuration
        # copyToClipboard
        history
        betterGenres
        # savePlaylists
        sectionMarker
      ];

      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        marketplace
        ncsVisualizer
      ];
    };

    home.packages = with pkgs-unstable; [
      spotify-player
    ];
  };

  flake.modules.combined.spotify = {...}: {
    hm.imports = [config.flake.modules.homeManager.spotify];
  };
}
