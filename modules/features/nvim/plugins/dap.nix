{
  programs.nixvim.plugins.dap = {
    enable = true;
    settings = {
      adapters = {
        delve = {
          type = "server";
          port = "\${port}";
          executable = {
            command = "dlv";
            args = [
              "dap"
              "-l"
              "127.0.0.1:\${port}"
            ];
          };
        };
        debugpy = {
          type = "executable";
          command = "python";
          args = [
            "-m"
            "debugpy.adapter"
          ];
        };
      };
      configurations = {
        go = [
          {
            type = "delve";
            name = "Delve: Debug";
            request = "launch";
            program = "\${workspaceFolder}/cmd/server";
          }
          {
            type = "delve";
            name = "Delve: Debug test";
            request = "launch";
            mode = "test";
            program = "\${workspaceFolder}/";
          }
        ];
        python = [
          {
            type = "debugpy";
            name = "Debug: Current file";
            request = "launch";
            program = "\${file}";
            python.__raw = "vim.fn.exepath('python')";
          }
        ];
      };
      listeners = {
        "event_initialized" = [
          {
            name = "dapui_config";
            callback.__raw = ''function() require("dapui").open() end'';
          }
        ];
        "event_terminated" = [
          {
            name = "dapui_config";
            callback.__raw = ''function() require("dapui").close() end'';
          }
        ];
        "event_exited" = [
          {
            name = "dapui_config";
            callback.__raw = ''function() require("dapui").close() end'';
          }
        ];
      };
    };
  };

  programs.nixvim.plugins.dap-virtual-text.enable = true;
  programs.nixvim.plugins.dap-ui.enable = true;

  programs.nixvim.keymaps = [
    {
      key = "<F5>";
      mode = "n";
      options.desc = "Debug: Start/Continue";
      action.__raw = ''function() require("dap").continue() end'';
    }
    {
      key = "<F10>";
      mode = "n";
      options.desc = "Debug: Step Over";
      action.__raw = ''function() require("dap").step_over() end'';
    }
    {
      key = "<F11>";
      mode = "n";
      options.desc = "Debug: Step Into";
      action.__raw = ''function() require("dap").step_into() end'';
    }
    {
      key = "<F12>";
      mode = "n";
      options.desc = "Debug: Step Out";
      action.__raw = ''function() require("dap").step_out() end'';
    }
    {
      key = "<leader>db";
      mode = "n";
      options.desc = "Debug: Toggle Breakpoint";
      action.__raw = ''function() require("dap").toggle_breakpoint() end'';
    }
    {
      key = "<leader>dB";
      mode = "n";
      options.desc = "Debug: Conditional Breakpoint";
      action.__raw = ''
        function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end
      '';
    }
    {
      key = "<leader>du";
      mode = "n";
      options.desc = "Debug: Toggle UI";
      action.__raw = ''function() require("dapui").toggle() end'';
    }
  ];
}
