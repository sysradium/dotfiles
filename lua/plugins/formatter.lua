return {
	"mhartington/formatter.nvim",
	config = function()
		require("formatter").setup({
			filetype = {
				html = { require("formatter.filetypes.html").prettier },
				go = { require("formatter.filetypes.go").goimports },
				lua = { require("formatter.filetypes.lua").stylua },
				typescript = { require("formatter.filetypes.typescript").prettier },
				typescriptreact = { require("formatter.filetypes.typescript").prettier },
				python = { require("formatter.filetypes.python").black },
				sh = { require("formatter.filetypes.sh").shfmt },
				json = { require("formatter.filetypes.json").jq },
				["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
			},
		})

		local augroup = vim.api.nvim_create_augroup
		local autocmd = vim.api.nvim_create_autocmd
		augroup("__formatter__", { clear = true })
		autocmd("BufWritePost", { group = "__formatter__", command = ":FormatWrite" })
	end,
}
