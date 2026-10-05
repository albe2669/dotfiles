{
  programs.nixvim.plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "everforest";
        component_separators = {
          left = "";
          right = "";
        };
        section_separators = {
          left = "";
          right = "";
        };
        disabled_filetypes = {
          statusline = ["snacks_dashboard"];
        };
        always_divide_middle = true;
        globalstatus = true;
      };
      sections = {
        lualine_a = ["mode"];
        lualine_b = [
          "branch"
          {
            "diff" = 1;
            symbols = {
              added = " ";
              modified = " ";
              removed = " ";
            };
          }
          {
            "diagnostics" = 1;
            symbols = {
              error = " ";
              warn = " ";
              info = " ";
              hint = " ";
            };
          }
        ];
        lualine_c = [
          {
            "filename" = 1;
            path = 1;
            symbols = {
              modified = " ";
              readonly = " ";
              unnamed = "[No Name]";
            };
          }
        ];
        lualine_x = [
          {
            # Direnv status (active/pending/blocked)
            __unkeyed.__raw = ''
              function()
                local ok, result = pcall(require("direnv").statusline)
                if not ok then return "" end
                return result
              end
            '';
            color = {
              fg = "#d699b6";
            };
          }
          {
            # Macro recording indicator
            __unkeyed.__raw = ''
              function()
                local recording = vim.fn.reg_recording()
                if recording == "" then return "" end
                return "recording @" .. recording
              end
            '';
            color = {
              fg = "#e67e80";
            };
          }
          "searchcount"
          "selectioncount"
          {
            # Copilot connection indicator
            __unkeyed.__raw = ''
              function()
                local ok, result = pcall(function()
                  local client = require("copilot.client")
                  if client.is_disabled and client.is_disabled() then return "" end
                  return client.get() and "" or ""
                end)
                if not ok then return "" end
                return result
              end
            '';
            color = {
              fg = "#a7c080";
            };
          }
          {
            # Attached LSP client names
            __unkeyed.__raw = ''
              function()
                local bufnr = vim.api.nvim_get_current_buf()
                local clients = vim.lsp.get_clients({ bufnr = bufnr })
                if next(clients) == nil then return "" end
                local names = {}
                for _, client in ipairs(clients) do
                  table.insert(names, client.name)
                end
                return " " .. table.concat(names, ", ")
              end
            '';
            color = {
              fg = "#7fbbb3";
            };
          }
          {
            "encoding" = 1;
            show_bom = true;
          }
          {
            "fileformat" = 1;
          }
          {
            "filetype" = 1;
          }
        ];
        lualine_y = ["progress"];
        lualine_z = ["location"];
      };
      inactive_sections = {
        lualine_a = [];
        lualine_b = [];
        lualine_c = [
          {
            "filename" = 1;
            path = 1;
          }
        ];
        lualine_x = ["location"];
        lualine_y = [];
        lualine_z = [];
      };
      tabline = {};
    };
  };
}
