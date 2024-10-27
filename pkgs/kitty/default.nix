{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "kitty";
  version = "v0.9.0";

  src = fetchFromGitHub {
    owner = "avborup";
    repo = pname;
    rev = version;
    sha256 = "sha256-6/ednV6hpTObID8VgSxu0xw23DI9Njvz1UuGVWrQH0g=";
  };

  cargoSha256 = "sha256-S8e2dVf56WXJLPoU44iM64rvAOQCfr++DzfFxX6p3Fg=";

  nativeBuildInputs = [pkg-config];
  buildInputs = [libiconv openssl];

  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/kitty --help
  '';

  meta = with lib; {
    description = "Kitty is a CLI for interacting with Kattis that allows you to test and submit problems straight from your terminal.";
    homepage = "https://github.com/avborup/kitty";
    license = with licenses; [mit];
    maintainers = ["Adrian Borup" "Albert Rise Nielsen"];
    mainProgram = "kitty";
  };
}
