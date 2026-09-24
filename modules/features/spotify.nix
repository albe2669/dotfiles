{inputs, ...}: {
  category = "Software";
  name = "spotify";

  homeManager = {
    inputs,
    system,
    pkgs,
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
      genresSrc = pkgs.fetchzip {
        url = "https://code.vexcited.com/spicetify/genres/releases/download/0.1.0/genres-0.1.0.zip";
        hash = "sha256-80WFlkowiaG6+nUXVyE6ULYSlTT4jB93LjczPepcNqk=";
        stripRoot = false;
      };
    in {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        fullAlbumDate
        listPlaylistsWithSong
        wikify
        showQueueDuration
        history
        sectionMarker
        {
          name = "betterGenres.js";
          src = pkgs.runCommand "betterGenres" {} ''
            mkdir $out
            cp ${genresSrc}/index.js $out/betterGenres.js
          '';
        }
      ];

      enabledSnippets = [
        (builtins.readFile (genresSrc + "/index.css"))
      ];

      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        marketplace
        ncsVisualizer
      ];
    };
  };
}
