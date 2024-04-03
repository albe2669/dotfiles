let
  username = "goose";
in {
  inherit username;

  dotfilesLocation = "/home/${username}/Documents/Other/dotfiles";

  git = {
    username = "albe2669";
    email = "albert@risenielsen.dk";
  };
}
