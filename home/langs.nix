{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    nodejs_22

    # Go
    pkgs-unstable.go
    pkgs-unstable.golangci-lint

    # Rust
    cargo
    rustc
    clippy
    openssl # openssl-sys
    pkg-config # openssl-sys

    # Java, also required by Scala metals
    jdk11

    # COBOL
    gnu-cobol

    # clojure
    clojure
    leiningen
  ];
}
