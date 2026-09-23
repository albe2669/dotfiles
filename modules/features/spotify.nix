{inputs, ...}: {
  category = "Software";
  name = "spotify";

  homeManager = {
    inputs,
    system,
    ...
  }: {
    imports = [
      inputs.spicetify-nix.homeManagerModules.default
    ];

    stylix.targets = {
      spicetify.enable = true;
    };

    programs.spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
    in {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        fullAlbumDate
        listPlaylistsWithSong
        wikify
        showQueueDuration
        history
        betterGenres
        sectionMarker
      ];

      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        marketplace
        ncsVisualizer
      ];
    };
  };
}
