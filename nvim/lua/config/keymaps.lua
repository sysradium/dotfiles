local keyset = vim.keymap.set
-- Normal mode mappings
keyset("n", "]q", ":cnext<CR>")
keyset("n", "[q", ":cprev<CR>")
keyset("n", "]b", ":bn<CR>")
keyset("n", "[b", ":bp<CR>")
keyset("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
keyset("n", "<leader>fb", "<cmd>Telescope buffers<CR>")
keyset("n", "<leader>gg", ":LazyGit<CR>", { silent = true })
