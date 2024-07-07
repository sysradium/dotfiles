-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require("config.lazy")
--require("lsp_config")
require("navigator").setup({ main = true })
-- Some servers have issues with backup files, see #649
vim.opt.backup = false
vim.opt.writebackup = false

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
vim.opt.updatetime = 80

vim.cmd.colorscheme("catppuccin-mocha")

vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#8c92a8", italic = true, bold = false })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#f9e2af", bold = false })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#b6bed9", bold = false })
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloating", { bg = "none" })
