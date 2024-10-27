{pkgs-unstable, ...}: {
  home.packages = [
    (pkgs-unstable.callPackage ../pkgs/anytype {})
  ];
}
