{
  config,
  lib,
  pkgs-unstable,
  ...
}: let
  # Declarative omp plugin list. To add or remove a plugin, edit this
  # list — the activation script reinstalls when package.json changes.
  plugins = [
    {
      name = "@dietrichgebert/ponytail";
      spec = "https://github.com/DietrichGebert/ponytail";
      version = "4.9.0";
    }
    {
      name = "@qoderai/better-harness";
      spec = "https://github.com/QoderAI/better-harness";
      version = "0.4.0";
    }
    {
      name = "context-mode";
      spec = "^1.0.162";
      version = "1.0.162";
    }
  ];

  packageJson = pkgs-unstable.writeText "omp-plugins-package.json" (
    builtins.toJSON {
      name = "omp-plugins";
      private = true;
      dependencies = builtins.listToAttrs (
        map (p: {
          inherit (p) name;
          value = p.spec;
        })
        plugins
      );
    }
  );

  pluginsLock = pkgs-unstable.writeText "omp-plugins-lock.json" (
    builtins.toJSON {
      plugins = builtins.listToAttrs (
        map (p: {
          inherit (p) name;
          value = {
            inherit (p) version;
            enabledFeatures = null;
            enabled = true;
          };
        })
        plugins
      );
      settings = {};
    }
  );
in {
  xdg.configFile."omp/plugins/package.json".source = packageJson;
  xdg.configFile."omp/plugins/omp-plugins.lock.json".source = pluginsLock;

  home.activation.installOmpPlugins = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH="${pkgs-unstable.bun}/bin:$PATH"
    PLUGINS_DIR="${config.xdg.configHome}/omp/plugins"
    HASH_FILE="$PLUGINS_DIR/.package-hash"
    CURRENT_HASH=$(readlink "$PLUGINS_DIR/package.json" 2>/dev/null || echo "")
    if [ "$CURRENT_HASH" != "$(cat "$HASH_FILE" 2>/dev/null)" ]; then
      mkdir -p "$PLUGINS_DIR"
      cd "$PLUGINS_DIR" && bun install --no-save 2>&1 || true
      printf '%s' "$CURRENT_HASH" > "$HASH_FILE"
    fi
  '';
}
