return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		lsp = {
			override = {
				["cmp.entry.get_documentation"] = false,
			},
		},
	},
}
