-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
vim.cmd.colorscheme "catppuccin-mocha"

require("catppuccin").setup({
    flavour = "mocha",
    background = {light = "latte", dark = "mocha"},
    indent_blankline = {enabled = true, colored_indent_levels = false},
    integrations = {
        alpha = true,
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = true,
        treesitter_context = true,
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = {"italic"},
                hints = {"italic"},
                warnings = {"italic"},
                information = {"italic"}
            },
            underlines = {
                errors = {"underline"},
                hints = {"underline"},
                warnings = {"underline"},
                information = {"underline"}
            },
            inlay_hints = {background = true}
        }
    }
})

vim.api.nvim_set_hl(0, 'LineNrAbove', {fg = '#a6adc8', bold = true})
vim.api.nvim_set_hl(0, 'LineNr', {fg = '#f9e2af', bold = true})
vim.api.nvim_set_hl(0, 'LineNrBelow', {fg = '#cdd6f4', bold = true})
vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
vim.api.nvim_set_hl(0, "NormalFloating", {bg = "none"})
