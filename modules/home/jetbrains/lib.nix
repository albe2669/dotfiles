{
  system,
  pkgs-unstable,
  inputs,
  isDarwin,
}: let
  overrideIde = ide:
    if !isDarwin
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
    "net.ashald.envfile"
  ];

  createIde = ide-name: extraPlugins: let
    ide = overrideIde ide-name;
    # pluginsForIdeWith with dontOverride for copilot so addPlugins patches it correctly
    plugins =
      inputs.nix-jetbrains-plugins.lib.pluginsForIdeWith {
        applyPluginOverrides = true;
      }
      pkgs-unstable
      ide (commonPlugins ++ extraPlugins);
  in
    (pkgs-unstable.jetbrains.plugins.addPlugins ide (builtins.attrValues plugins)).overrideAttrs {
      disallowedReferences = [];
    };
in {
  inherit createIde;
}
