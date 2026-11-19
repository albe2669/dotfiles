{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  unzip,
  coreutils,
  makeWrapper,
  jdk25,
  autoPatchelfHook,
}: let
  version = "271.2085.0";

  # JetBrains ships one archive per platform; the old flat
  # kotlin-server-VER.tar.gz no longer exists.
  assets = {
    "aarch64-darwin" = {
      url = "https://download.jetbrains.com/language-server/kotlin-server/${version}/kotlin-server-${version}-aarch64.sit";
      hash = "sha256-LSI4j1i+b036eo8YweIxhxFk3KzBbkB1WQKdcjKBa0o=";
    };
    "x86_64-darwin" = {
      url = "https://download.jetbrains.com/language-server/kotlin-server/${version}/kotlin-server-${version}.sit";
      hash = "sha256-aEV6sYJTMePqyFGRt8MnN8vYmThn9anFDf4BLFUJ6Pc=";
    };
    "aarch64-linux" = {
      url = "https://download.jetbrains.com/language-server/kotlin-server/${version}/kotlin-server-${version}-aarch64.tar.gz";
      hash = "sha256-h3ruYSoX2rSBREZigqZBTsWKtCihC5fH4T7dm2s9yW4=";
    };
    "x86_64-linux" = {
      url = "https://download.jetbrains.com/language-server/kotlin-server/${version}/kotlin-server-${version}.tar.gz";
      hash = "sha256-45jnmQJ/QXSeoz+qV0cDB9E9QPkQlhhYx+MK29d4rgg=";
    };
  };

  asset =
    assets.${stdenvNoCC.hostPlatform.system}
      or (throw "kotlin-lsp: unsupported system ${stdenvNoCC.hostPlatform.system}");

  # The launcher resolves jbr/Contents/Home/bin/java on darwin but
  # jbr/bin/java on Linux, so the symlink must point at the JDK bundle on
  # darwin and the Java home on Linux.
  jbr =
    if stdenvNoCC.hostPlatform.isDarwin
    then "${jdk25}/Library/Java/JavaVirtualMachines/zulu-25.jdk"
    else "${jdk25}/lib/openjdk";
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "kotlin-lsp";
    inherit version;

    # unpackPhase picks the unpacker from the source file extension; it has
    # none for .sit (a zip archive), so download it under a .zip name.
    src =
      if stdenvNoCC.hostPlatform.isDarwin
      then
        (fetchurl {
          inherit (asset) url hash;
          name = "kotlin-server-${version}.zip";
        })
      else (fetchurl {inherit (asset) url hash;});

    nativeBuildInputs =
      [
        makeWrapper
        # timeout for the installCheck handshake
        coreutils
      ]
      ++ lib.optional stdenvNoCC.hostPlatform.isDarwin unzip
      ++ lib.optional (!stdenvNoCC.hostPlatform.isDarwin) autoPatchelfHook;

    buildInputs = [
      stdenv.cc.cc.lib
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/kotlin-lsp $out/bin
      cp -r bin build.txt kotlin-lsp.sh lib license modules plugins product-info.json $out/share/kotlin-lsp
      ln -s ${jbr} $out/share/kotlin-lsp/jbr

      # nvim-lspconfig launches kotlin_lsp as `intellij-server --stdio`;
      # kotlin-lsp stays as a convenience alias.
      makeWrapper $out/share/kotlin-lsp/bin/intellij-server $out/bin/intellij-server
      makeWrapper $out/share/kotlin-lsp/bin/intellij-server $out/bin/kotlin-lsp

      runHook postInstall
    '';

    # kotlin-lsp has no --version, so instead of versionCheckHook drive a
    # minimal LSP initialize handshake over stdio and assert the server
    # replies with a framed JSON-RPC message. This exercises the JVM launch
    # and the jbr symlink, which is where breakage tends to hide. The build
    # user's passwd home is /var/empty, and darwin Java derives user.home
    # from passwd rather than $HOME, so redirect it through IJ_JAVA_OPTIONS.
    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck

      req='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":null,"rootUri":null,"capabilities":{}}}'
      printf 'Content-Length: %d\r\n\r\n%s' "''${#req}" "$req" \
        | IJ_JAVA_OPTIONS="-Duser.home=$PWD" timeout 120 $out/bin/intellij-server --stdio > response.txt 2>&1 || true

      grep -q '"jsonrpc"' response.txt || {
        echo "kotlin-lsp did not respond to an LSP initialize request" >&2
        exit 1
      }

      runHook postInstallCheck
    '';

    meta = {
      description = "Official Kotlin language server built on the IntelliJ platform";
      homepage = "https://github.com/Kotlin/kotlin-lsp";
      license = lib.licenses.unfree;
      platforms = builtins.attrNames assets;
      mainProgram = "kotlin-lsp";
    };
  })
