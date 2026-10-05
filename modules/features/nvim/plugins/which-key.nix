{
  programs.nixvim.plugins.which-key = {
    enable = true;
    settings = {
      preset = "classic";
      delay.__raw = ''
        function(ctx) return ctx.timeout or 300 end
      '';
      filter.__raw = ''
        function(mapping) return mapping.desc and mapping.desc ~= "" end
      '';
      spec = [
        {
          mode = "n";
          __unkeyed = "<leader>l";
          group = "LSP";
        }
        {
          mode = "n";
          __unkeyed = "<leader>h";
          group = "Git hunk";
        }
        {
          mode = "n";
          __unkeyed = "<leader>d";
          group = "Debug";
        }
        {
          mode = "n";
          __unkeyed = "<leader>t";
          group = "Toggle";
        }
      ];
    };
  };
}
