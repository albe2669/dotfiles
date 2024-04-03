{ username, lib, ...}: 
let 
  dirs = ["Documents" "Downloads" "Music" "Pictures" "Videos"];
in {
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";

    activation = {
      createDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] (builtins.concatStringsSep "\n" (builtins.map(dir: "mkdir -p ~/${dir}") dirs));
    };
  };

  programs.home-manager.enable = true;
}
