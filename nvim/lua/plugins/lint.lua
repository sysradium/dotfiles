return {
	"mfussenegger/nvim-lint",
	opts = {
		linters_by_ft = {
			fish = { "fish" },
			go = { "golangcilint" },
		},
		-- LazyVim extension to easily override linter options
		-- or add custom linters.
		---@type table<string,table>
		linters = {
			golangcilint = {
				args = {
					"run",
					"--out-format",
					"json",
					"--show-stats=false",
					"--print-issued-lines=false",
					"--print-linter-name=false",
					"--no-config",
					"--disable=depguard",
					function()
						return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
					end,
				},
			},
		},
	},
}
