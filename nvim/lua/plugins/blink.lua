return {
	"saghen/blink.cmp",
	opts = {
		completion = {
			list = {
				selection = "preselect",
			},
		},
		keymap = {
			preset = "enter",
			["<Tab>"] = {
				LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
				"fallback",
			},
		},
	},
}
