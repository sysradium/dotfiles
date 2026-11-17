return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			basedpyright = {
				settings = {
					basedpyright = {
						analysis = {
							diagnosticSeverityOverrides = {
								reportAny = "none",
								reportUnannotatedClassAttribute = "none",
								reportMissingParameterType = "none",
								reportUnknownParameterType = "none",
								reportUnknownArgumentType = "none",
								reportUnknownVariableType = "none",
								reportUnknownMemberType = "none",
								reportUnknownLambdaType = "none",
							},
						},
					},
				},
			},
		},
	},
}
