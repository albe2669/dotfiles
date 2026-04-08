{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}:
let 
 go_pkg = pkgs-unstable.go_1_26;
in {
  home.packages = with pkgs;
    [
		  # Command runner
			just

			# NodeJS
      nodejs_22

      # Go
      go_pkg
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

    GOROOT = "${go_pkg}/share/go";
  };
}
