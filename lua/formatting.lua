require("formatter").setup {
    filetype = {
        go = {require("formatter.filetypes.go").goimports},
        lua = {require("formatter.filetypes.lua").luaformat}
    }
}

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", {clear = true})
autocmd("BufWritePost", {group = "__formatter__", command = ":FormatWrite"})
