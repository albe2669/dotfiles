if vim.fn.has("mac") == 1 then
  vim.g["clipboard"] = {
    name = "pbcopy",
    copy = {
      ["+"] = { "pbcopy" },
      ["*"] = { "pbcopy" }
    },
    paste = {
      ["+"] = { "pbpaste" },
      ["*"] = { "pbpaste" }
    },
    cache_enabled = 1
  }
else
  vim.g["clipboard"] = {
    name = "wl-copy",
    copy = {
      ["+"] = { "wl-copy", "-n" },
      ["*"] = { "wl-copy", "-n" }
    },
    paste = {
      ["+"] = { "wl-paste", "-n" },
      ["*"] = { "wl-paste", "-n" }
    },
    cache_enabled = 1
  }
end
