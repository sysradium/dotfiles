return {
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
	},
	"tpope/vim-repeat",
	"tpope/vim-surround",
	"lewis6991/gitsigns.nvim",
	"junegunn/vim-easy-align",
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},
	{ "VonHeikemen/fine-cmdline.nvim", dependencies = { { "MunifTanjim/nui.nvim" } } },
}
