-- Show the names of the LSP clients attached to the current buffer.
local function lsp_clients()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if next(clients) == nil then
    return ""
  end
  local names = {}
  for _, client in ipairs(clients) do
    if client.name ~= "null-ls" then
      table.insert(names, client.name)
    end
  end
  return " " .. table.concat(names, ", ")
end

-- Copilot connection indicator ( = connected,  = idle/disabled).
local function copilot_status()
  local ok, result = pcall(function()
    local client = require("copilot.client")
    if client.is_disabled and client.is_disabled() then
      return ""
    end
    return client.get() and "" or ""
  end)
  if not ok then
    return ""
  end
  return result
end

local opts = {
  options = {
    icons_enabled = true,
    theme = 'everforest',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = { "snacks_dashboard" },
    },
    always_divide_middle = true,
    globalstatus = true, -- single status line for the whole UI (laststatus=3)
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      'branch',
      { 'diff', symbols = { added = ' ', modified = ' ', removed = ' ' } },
      {
        'diagnostics',
        symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
      },
    },
    lualine_c = {
      { 'filename', path = 1, symbols = { modified = ' ', readonly = ' ', unnamed = '[No Name]' } },
    },
    lualine_x = {
      {
        function()
          local recording = vim.fn.reg_recording()
          if recording == "" then return "" end
          return "recording @" .. recording
        end,
        color = { fg = "#e67e80" },
      },
      'searchcount',
      'selectioncount',
      { copilot_status, color = { fg = "#a7c080" } },
      { lsp_clients, color = { fg = "#7fbbb3" } },
      { 'encoding', show_bom = true },
      { 'fileformat' },
      { 'filetype' },
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = { 'lazy', 'mason', 'quickfix' },
}

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = "VeryLazy",
    config = function()
      require("lualine").setup(opts)
    end,
  },
}
