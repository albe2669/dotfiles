vim.g["clipboard"] = {
  name = "wl-copy",
  copy = {
    ["+"] = { "wl-copy" },
    ["*"] = { "wl-copy" }
  },
  paste = {
    ["+"] = { "wl-paste" },
    ["*"] = { "wl-paste" }
  },
  cache_enabled = 1
}
