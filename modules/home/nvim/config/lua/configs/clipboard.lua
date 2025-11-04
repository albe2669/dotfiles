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
