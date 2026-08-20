lib: pkgs: {
  combinedSkillsBundle = import ./bundles/default.nix {
    inherit pkgs;
    mkSkillsBundle = import ../../../lib/skills-bundle.nix lib pkgs;
  };

  sharedContext = ./context.md;

  notifyScript = {
    title,
    defaultMsg ? "Agent stopped",
    ...
  }: ''
    #!/usr/bin/env bash
    input=$(cat)
    msg=$(printf '%s' "$input" | jq -r '.message // "${defaultMsg}"' 2>/dev/null || echo "${defaultMsg}")

    if [[ "$(uname)" == "Darwin" ]]; then
      osascript -e "display notification \"$msg\" with title \"${title}\""
    elif command -v notify-send &>/dev/null; then
      notify-send "${title}" "$msg"
    fi
  '';
}
