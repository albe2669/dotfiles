{
  category = "Programming languages";
  name = "clojure";
  software = [
    "clojure"
    "leiningen"
  ];

  homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      clojure
      leiningen
    ];
  };
}
