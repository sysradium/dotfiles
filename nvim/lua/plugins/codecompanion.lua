return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = true,
	opts = {
		adapters = {
			copilot = function()
				return require("codecompanion.adapters").extend("copilot", {
					name = "copilot",
					schema = {
						model = {
							default = "claude-3.7-sonnet", -- or "claude-3.7-sonnet" if available
						},
					},
				})
			end,
			opts = {
				show_model_choices = true,
			},
		},
	},
}
