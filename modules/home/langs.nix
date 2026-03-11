{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs;
    [
      nodejs_22

      # Go
      pkgs-unstable.go
      pkgs-unstable.golangci-lint

      # Rust
      pkgs-unstable.cargo
      pkgs-unstable.rustc
      pkgs-unstable.rustfmt
      pkgs-unstable.clippy
      openssl # openssl-sys
      pkg-config # openssl-sys

      # Java, also required by Scala metals
      jdk17

      # clojure
      clojure
      leiningen

      opentofu

      # AI
      pkgs-unstable.gemini-cli

      # Erlang
      erlang_28
    ]
    ++ lib.optionals config.opts.variables.isDarwin [
      pkgs.apple-sdk
    ];

  home.sessionVariables = lib.mkIf config.opts.variables.isDarwin {
    LIBRARY_PATH = lib.makeLibraryPath [
      pkgs.darwin.libresolv
    ];

		GOROOT = "${pkgs-unstable.go}/share/go";
  };
}
