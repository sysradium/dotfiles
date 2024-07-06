-- set termguicolors to enable highlight groups
vim.cmd.colorscheme("catppuccin-mocha")

vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#8c92a8", italic = true, bold = false })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#f9e2af", bold = false })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#b6bed9", bold = false })
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloating", { bg = "none" })
