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

    # Java, also required by Scala metals
    jdk11

    # PHP
    php83
    php83Packages.composer

    # COBOL
    gnu-cobol
  ];
}
