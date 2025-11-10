{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  home.packages = with pkgs; [
    nodejs_22

    # Go
    pkgs-unstable.go
    pkgs-unstable.golangci-lint

    # Rust
    cargo
    rustc
    rustfmt
    clippy
    openssl # openssl-sys
    pkg-config # openssl-sys

    # Java, also required by Scala metals
    jdk17

    # clojure
    clojure
    leiningen

    opentofu

    # C#
    dotnetCorePackages.dotnet_9.sdk
    azure-functions-core-tools
    azurite

    # AI
    pkgs-unstable.claude-code
    pkgs-unstable.gemini-cli

    # Erlang
    erlang_28
  ];
}
