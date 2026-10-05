{
  programs.nixvim.plugins.blink-cmp = {
    enable = true;
    settings = {
      keymap = {
        preset = "super-tab";
        "<CR>" = [
          "accept"
          "fallback"
        ];
        "<C-Space>" = [
          "show"
          "show_documentation"
          "hide_documentation"
        ];
        "<C-e>" = [
          "hide"
          "fallback"
        ];
        "<C-d>" = [
          "scroll_documentation_down"
          "fallback"
        ];
        "<C-f>" = [
          "scroll_documentation_up"
          "fallback"
        ];
      };
      appearance.nerd_font_variant = "mono";
      completion = {
        accept.auto_brackets.enabled = true;
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 200;
        };
        ghost_text.enabled = true;
        menu.draw.columns = [
          {
            __unkeyed-1 = "label";
            __unkeyed-2 = "label_description";
            gap = 1;
          }
          {
            __unkeyed-1 = "kind_icon";
            __unkeyed-2 = "kind";
            gap = 1;
          }
          {__unkeyed-1 = "source_name";}
        ];
      };
      signature.enabled = true;
      sources.default = [
        "lsp"
        "path"
        "snippets"
        "buffer"
      ];
    };
  };
}
