{
  category = "Programming languages";
  name = "java";
  software = [
    "jdk17"
    "jdt-language-server"
    "google-java-format"
  ];

  homeManager = {
    pkgs,
    pkgs-unstable,
    ...
  }: {
    home.packages = [
      pkgs.jdk17
      pkgs-unstable.jdt-language-server
      pkgs-unstable.google-java-format
    ];
  };
}
