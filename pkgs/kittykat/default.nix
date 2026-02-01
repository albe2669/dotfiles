{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "kittykat";
  version = "v0.9.0";

  src = fetchFromGitHub {
    owner = "avborup";
    repo = "kitty";
    rev = version;
    sha256 = "sha256-6/ednV6hpTObID8VgSxu0xw23DI9Njvz1UuGVWrQH0g=";
  };

  cargoHash = "sha256-e0RLFtfr0iZTFxIIS5ExWOgc9YlLstitj7Im9AQFtlo=";

  nativeBuildInputs = [pkg-config];
  buildInputs = [libiconv openssl];

  doCheck = false;

  postInstall = ''
    mv $out/bin/kitty $out/bin/kittykat
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/kittykat --help
  '';

  meta = with lib; {
    description = "Kitty is a CLI for interacting with Kattis that allows you to test and submit problems straight from your terminal.";
    homepage = "https://github.com/avborup/kitty";
    license = with licenses; [mit];
    maintainers = ["Adrian Borup" "Albert Rise Nielsen"];
    mainProgram = "kittykat";
  };
}
