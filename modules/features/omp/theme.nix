{config, ...}: let
  # Everforest Dark Hard, derived from the stylix base16 scheme
  # (modules/features/stylix/everforest-dark-hard.yaml) so the omp theme
  # tracks the same palette as the rest of the system.
  #
  # stylix exposes `baseXX-hex` without a leading '#'; omp wants '#RRGGBB'.
  base = config.lib.stylix.colors;
  hex = key: "#" + base."${key}-hex";

  # Extended everforest accents not present in the base16 scheme.
  # Dark Hard variant values (matching the stylix scheme), from
  # sainnhe/everforest palette.md dark-hard palette1.
  bgGreen = "#3c4841";
  bgRed = "#493b40";
in {
  home.file.".omp/agent/themes/everforest.json".text = builtins.toJSON {
    "$schema" = "https://raw.githubusercontent.com/can1357/oh-my-pi/main/packages/coding-agent/theme-schema.json";
    name = "everforest";
    vars = {
      bg0 = hex "base00";
      bg1 = hex "base01";
      bg2 = hex "base02";
      comment = hex "base03";
      fg = hex "base05";
      red = hex "base08";
      orange = hex "base09";
      yellow = hex "base0A";
      green = hex "base0B";
      aqua = hex "base0C";
      blue = hex "base0D";
      purple = hex "base0E";
      grey0 = hex "base04";
      grey1 = hex "base03";
      grey2 = "#9da9a0";
      inherit bgGreen;
      inherit bgRed;
    };
    colors = {
      # Everforest highlighting semantics (sainnhe/everforest palette.md):
      # green = functions/strings/hints/success/statusline mode (workhorse),
      # red = keywords/errors/diff-removed, orange = operators,
      # yellow = types/warnings, aqua = constants/macros (narrow),
      # blue = identifiers, purple = numbers/booleans (narrow),
      # fg = variables, grey1 = comments/punctuation/borders.
      # Green leads; red/orange/yellow carry semantic weight, not decoration.

      # --- Core text and borders (11) ---
      accent = "green";
      border = "grey1";
      borderAccent = "green";
      borderMuted = "bg1";
      success = "green";
      error = "red";
      warning = "yellow";
      muted = "grey2";
      dim = "grey0";
      text = "fg";
      thinkingText = "grey1";

      # --- Background blocks (7) ---
      selectedBg = "bg2";
      userMessageBg = "bg1";
      customMessageBg = "bg1";
      toolPendingBg = "bg1";
      toolSuccessBg = "bgGreen";
      toolErrorBg = "bgRed";
      statusLineBg = "bg0";

      # --- Message/tool text (5) ---
      userMessageText = "fg";
      customMessageText = "fg";
      customMessageLabel = "green";
      toolTitle = "fg";
      toolOutput = "grey2";

      # --- Markdown (10) ---
      mdHeading = "fg";
      mdLink = "green";
      mdLinkUrl = "grey1";
      mdCode = "green";
      mdCodeBlock = "fg";
      mdCodeBlockBorder = "grey1";
      mdQuote = "grey1";
      mdQuoteBorder = "grey1";
      mdHr = "grey1";
      mdListBullet = "green";

      # --- Tool diff + syntax highlighting (12) ---
      toolDiffAdded = "green";
      toolDiffRemoved = "red";
      toolDiffContext = "grey1";
      syntaxComment = "grey1";
      syntaxKeyword = "red";
      syntaxFunction = "green";
      syntaxVariable = "fg";
      syntaxString = "green";
      syntaxNumber = "purple";
      syntaxType = "yellow";
      syntaxOperator = "orange";
      syntaxPunctuation = "grey1";

      # --- Mode/thinking borders (8) ---
      thinkingOff = "grey0";
      thinkingMinimal = "grey1";
      thinkingLow = "green";
      thinkingMedium = "yellow";
      thinkingHigh = "orange";
      thinkingXhigh = "red";
      bashMode = "orange";
      pythonMode = "yellow";

      # --- Status line segment colors (13) ---
      statusLineSep = "grey1";
      statusLineModel = "green";
      statusLinePath = "fg";
      statusLineGitClean = "green";
      statusLineGitDirty = "yellow";
      statusLineContext = "grey2";
      statusLineSpend = "orange";
      statusLineStaged = "green";
      statusLineDirty = "yellow";
      statusLineUntracked = "red";
      statusLineOutput = "fg";
      statusLineCost = "orange";
      statusLineSubagents = "blue";
    };
    export = {
      pageBg = "bg0";
      cardBg = "bg1";
      infoBg = "bg2";
    };
  };
}
