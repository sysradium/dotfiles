return {
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},
	"tpope/vim-repeat",
	"tpope/vim-surround",
	"lewis6991/gitsigns.nvim",
	"kdheepak/lazygit.nvim",
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
