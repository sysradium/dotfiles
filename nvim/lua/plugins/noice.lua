return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim", -- OPTIONAL:
        "rcarriga/nvim-notify",
    },
    config = function()
        require("notify").setup({ background_colour = "#000000" })
        require("noice").setup({
            lsp = { hover = { enabled = false } },
            views = {
                cmdline_popup = {
                    border = { style = "rounded", padding = { 0, 0 } },
                    filter_options = {},
                    position = { row = 17, col = "50%" },
                    size = { width = 60 },
                    win_options = {
                        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                    },
                },
                popupmenu = {
                    relative = "editor",
                    position = { row = 27, col = "50%" },
                    size = { width = 60, height = 10 },
                    border = { style = "rounded", padding = { 0, 0 } },
                    win_options = {
                        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                    },
                },
                presets = {
                    bottom_search = true, -- use a classic bottom cmdline for search
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false, -- add a border to hover docs and signature help
                },
            },
        })
    end,
}
