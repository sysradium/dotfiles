return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = true,
	opts = {
		adapters = {
			ollama = function()
				return require("codecompanion.adapters").extend("openai_compatible", {
					env = {
						url = "http://localhost:1234",
						api_key = "OpenAI_API_KEY",
						chat_url = "/v1/chat/completions",
					},
				})
			end,
		},
		strategies = {
			chat = {
				adapter = "ollama",
			},
			inline = {
				adapter = "ollama",
			},
		},
	},
}
