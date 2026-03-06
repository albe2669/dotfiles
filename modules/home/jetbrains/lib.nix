{
  system,
  pkgs-unstable,
  inputs,
}: let
  isLinux = builtins.match ".*-linux" system != null;

  overrideIde = ide:
    if isLinux
    then
      pkgs-unstable.jetbrains."${ide}".override {
        vmopts = ''
          -Dawt.toolkit.name=WLToolkit
        '';
      }
    else pkgs-unstable.jetbrains."${ide}";

  commonPlugins = [
    "IdeaVIM"
    "dev.turingcomplete.intellijdevelopertoolsplugins"
    "com.intellij.resharper.azure"
    "mobi.hsz.idea.gitignore"
    "com.github.catppuccin.jetbrains"
    "com.github.catppuccin.jetbrains_icons"
    "com.intellij.lang.jsgraphql"
    "com.wakatime.intellij.plugin"
    "com.github.lppedd.idea-conventional-commit"
    "org.intellij.plugins.hcl"
    "org.jetbrains.plugins.github"
    "com.github.copilot"
  ];

  createIde = ide-name: extraPlugins: let
    ide = overrideIde ide-name;
    plugins = builtins.map (p: inputs.nix-jetbrains-plugins.plugins."${system}"."${ide.pname}"."${ide.version}"."${p}") (commonPlugins ++ extraPlugins);
  in
    # Workaround for https://github.com/NixOS/nixpkgs/issues/417137
    # addPlugins only patches text files in bin/, but IDE binaries elsewhere
    # still reference the unwrapped store path, failing disallowedReferences.
    (pkgs-unstable.jetbrains.plugins.addPlugins ide plugins).overrideAttrs {
      disallowedReferences = [];
    };
in {
  inherit createIde;
}
