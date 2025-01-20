return {
	"saghen/blink.cmp",
	opts = {
		completion = {
			list = {
				selection = { preselect = true, auto_insert = true },
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
