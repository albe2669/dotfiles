{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}: let
  version = "1.2.1";

  assets = {
    "aarch64-darwin" = {
      url = "https://github.com/unstablebuild/rune/releases/download/v${version}/Rune-v${version}-darwin-arm64.dmg";
      hash = "sha256-J9D3WkSWLxBaZ8YNtXCXZYPYzJkCCdbhsOTnAHeb7fw=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/unstablebuild/rune/releases/download/v${version}/Rune-v${version}-darwin-amd64.dmg";
      hash = "sha256-GSCH8ggBDBT3SppH0I3utQwJZieiMxpQBPcRPsvQvuc=";
    };
    "aarch64-linux" = {
      url = "https://github.com/unstablebuild/rune/releases/download/v${version}/rune-v${version}-linux-arm64.tar.gz";
      hash = "sha256-oHyzynWymapWCakJ9rXyTAGz88WwjEFkqOEg00NVevE=";
    };
    "x86_64-linux" = {
      url = "https://github.com/unstablebuild/rune/releases/download/v${version}/rune-v${version}-linux-amd64.tar.gz";
      hash = "sha256-nPF8ynEXLH3PMJTig3sh69xQSSBUbLi4fXzY4fMvJAA=";
    };
  };

  asset =
    assets.${stdenvNoCC.hostPlatform.system}
      or (throw "rune: unsupported system ${stdenvNoCC.hostPlatform.system}");
in
  stdenvNoCC.mkDerivation (_: {
    pname = "rune";
    inherit version;

    src = fetchurl {
      inherit (asset) url hash;
    };

    nativeBuildInputs =
      if stdenvNoCC.hostPlatform.isDarwin
      then [_7zz]
      else [];

    dontConfigure = true;
    dontBuild = true;

    installPhase =
      if stdenvNoCC.hostPlatform.isDarwin
      then ''
        runHook preInstall

        7zz x $src -o$TMPDIR/extracted
        mkdir -p $out/Applications
        cp -R $TMPDIR/extracted/Rune/Rune.app $out/Applications/Rune.app

        # 7zz materializes HFS extended attributes as regular files
        # (e.g. "Contents:com.apple.provenance"); these are not part of
        # the app bundle and break codesign ("unsealed contents in the
        # bundle root").
        find $out/Applications/Rune.app -maxdepth 1 -type f -delete

        # Re-sign ad-hoc; the nix store copy invalidates the original
        # signature and triggers the "damaged" gatekeeper prompt.
        /usr/bin/codesign --force --deep --sign - $out/Applications/Rune.app

        mkdir -p $out/bin
        ln -s $out/Applications/Rune.app/Contents/MacOS/rune $out/bin/rune

        runHook postInstall
      ''
      else ''
        runHook preInstall

        mkdir -p $out
        tar xf $src --strip-components=1 -C $out

        # Move bin from rune.app/bin to $out/bin so it's on PATH
        mkdir -p $out/bin
        ln -s $out/rune.app/bin/rune $out/bin/rune

        # Install desktop entry and icons
        install -D $out/rune.app/share/applications/rune.desktop $out/share/applications/rune.desktop
        install -D $out/rune.app/share/icons/hicolor/1024x1024/apps/rune.png $out/share/icons/hicolor/1024x1024/apps/rune.png
        install -D $out/rune.app/share/icons/hicolor/512x512/apps/rune.png $out/share/icons/hicolor/512x512/apps/rune.png

        runHook postInstall
      '';

    meta = {
      description = "Fast, GPU-accelerated IDE and terminal multiplexer";
      homepage = "https://rune.build";
      changelog = "https://github.com/unstablebuild/rune/releases/tag/v${version}";
      license = lib.licenses.gpl3Plus;
      platforms = builtins.attrNames assets;
      mainProgram = "rune";
    };
  })
