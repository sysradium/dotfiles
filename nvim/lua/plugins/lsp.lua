return {
	"neovim/nvim-lspconfig",
	opts = {
		capabilities = {
			textDocument = {
				completion = {
					completionItem = {
						snippetSupport = false, -- Disables function signature placeholders
					},
				},
			},
		},
	},
}
