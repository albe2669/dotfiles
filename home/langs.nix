{pkgs, ...}: {
  home.packages = with pkgs; [
    dotnet-sdk_7
    nodejs-18_x

    # Go
    go
    golangci-lint

    # Rust
    cargo
    rustc
    clippy
    openssl # openssl-sys
    pkg-config # openssl-sys

    # Scala
    scala
    scala-cli
    scalafmt
    scalafix
    coursier

    # Java, also required by Scala metals
    jdk11

    # PHP
    php81
    php81Packages.composer

    # COBOL
    gnu-cobol
  ];
}
