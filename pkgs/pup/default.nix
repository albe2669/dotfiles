{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  perl,
}:
rustPlatform.buildRustPackage rec {
  pname = "pup";
  version = "0.46.0";

  src = fetchFromGitHub {
    owner = "datadog-labs";
    repo = "pup";
    rev = "v${version}";
    hash = "sha256-47MUYqj0dS5TyxeJge3pQ9EEN0wR02gCcYMzfLabb9Q=";
  };

  cargoHash = "sha256-3bjucBw5RBvw19yxEEkJ69LI2KpK0KJKCdCFrTMeqWs=";

  nativeBuildInputs = [pkg-config perl];
  buildInputs = [openssl];

  buildFeatures = ["native" "vendored-openssl"];

  doCheck = false;

  meta = with lib; {
    description = "A CLI that gives your agents full access to Datadog's observability platform";
    homepage = "https://github.com/datadog-labs/pup";
    license = licenses.asl20;
    mainProgram = "pup";
  };
}
