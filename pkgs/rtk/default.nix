{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rtk";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "rtk-ai";
    repo = "rtk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QGHCa8rO4YBFXdrz78FhWKFxY7DmRxCXM8iYQv4yTYE=";
  };

  cargoHash = "sha256-gNJjtQah7NFSgFVYJftK19dECzDvLCi2E33na2PtKmc=";

  preBuild = ''
    substituteInPlace Cargo.toml --replace-fail 'features = ["bundled"]' 'features = []'
    cargo update --offline -p rusqlite
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    sqlite
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeInstallCheckInputs = [versionCheckHook];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "CLI proxy that reduces LLM token consumption by 60-90% on common dev commands";
    homepage = "https://github.com/rtk-ai/rtk";
    changelog = "https://github.com/rtk-ai/rtk/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ryoppippi];
    mainProgram = "rtk";
  };
})
