{
  programs.nixvim.plugins.markdown-preview = {
    enable = true;
    settings = {
      instance_mode = "takeover";
      port = "0";
      open_browser = true;
      default_theme = "dark";
      debounce_ms = 300;
    };
  };
}
