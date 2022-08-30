local api = vim.api

local get_map_options = function(custom_options)
    local options = { noremap = true, silent = true }
    if custom_options then
        options = vim.tbl_extend("force", options, custom_options)
    end
    return options
end

local interp = function(s, tab)
  return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end

local M = {}

M.map = function(mode, target, source, opts)
    api.nvim_set_keymap(mode, target, source, get_map_options(opts))
end

for _, mode in ipairs({ "n", "o", "i", "x", "t" }) do
    M[mode .. "map"] = function(...)
        M.map(mode, ...)
    end
end

M.buf_map = function(bufnr, mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
        silent = true,
    })
end

M.cmd = function(name, method)
  vim.cmd(interp("command! ${name} ${method}", {name = name, method = method}))
end

M.rq_cmd = function(name, library, method)
  vim.cmd(interp("command! ${name} :lua require('${library}').${method}", {name = name, library = library, method = method}))
end

return M
