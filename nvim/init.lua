-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require("config.lazy")

vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#8c92a8", italic = true, bold = false })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#f9e2af", bold = false })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#b6bed9", bold = false })
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloating", { bg = "none" })

vim.api.nvim_create_autocmd("BufWritePre", {
	buffer = buffer,
	callback = function()
		vim.lsp.buf.code_action({
			context = { only = { "source.organizeImports" } },
			apply = true,
		})
		vim.wait(100)
	end,
})
