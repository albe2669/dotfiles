{ lib
, fetchFromGitHub
, rustPlatform
, libiconv
, pkg-config
, openssl
# , docker
}: 

rustPlatform.buildRustPackage rec {
  pname = "kitty";
  version = "v0.8.0";

  src = fetchFromGitHub {
    owner = "albe2669";
    repo = pname;
    rev = "nix";
    sha256 = "sha256-D/9yp2n/Swoik6GUBUM71M5p45uqh67IvKDq/QQKA0I=";
  };

  cargoSha256 = "sha256-i/B9p5O5Xm9p3QebwNBnDBQWWM9l++ejTaHo2v9MLa8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libiconv openssl ];
  # checkInputs = [ libiconv openssl docker ];

  # checkPhase = ''
  #   export HOME=$(pwd)
  #   make test
  # '';

  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/kitty --help
  '';

  meta = with lib; {
    description = "Kitty is a CLI for interacting with Kattis that allows you to test and submit problems straight from your terminal.";
    homepage = "https://github.com/albe2669/kitty";
    license = with licenses; [ mit ];
    maintainers = ["Adrian Borup" "Albert Rise Nielsen"];
    mainProgram = "kitty";
  };
}

