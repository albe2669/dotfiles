# Naming this file was one of the hardest things to do apparently. Both config, options, setting and args were already taken.
# So yes, it's a stupid name, but i can't be arsed anymore
let
  username = "goose";
  homeDirectory = builtins.toPath "/home/${username}";
in {
  inherit username;

  homeDirectory = {
    path = homeDirectory;
    directories = ["Documents" "Downloads" "Music" "Pictures" "Videos"];
  };

  git = {
    username = "albe2669";
    email = "albert@risenielsen.dk";
  };

  dotfilesLocation = homeDirectory + (builtins.toPath "/Documents/Other/dotfiles");

  stateVersion = "23.11";
}
