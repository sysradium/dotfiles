return {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = function(_, opts)
        local mocha = require("catppuccin.palettes").get_palette "mocha"
        opts.options = {
            {diagnostics = "nvim_lsp"},
            highlights = require("catppuccin.groups.integrations.bufferline").get {
                styles = {"italic", "bold"},
                custom = {
                    all = {fill = {bg = "#000000"}},
                    mocha = {background = {fg = mocha.text}},
                    latte = {background = {fg = "#000000"}}
                }
            }
        }
    end
}
