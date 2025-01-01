local keyset = vim.keymap.set
-- Normal mode mappings
keyset("n", "]q", ":cnext<CR>")
keyset("n", "[q", ":cprev<CR>")
