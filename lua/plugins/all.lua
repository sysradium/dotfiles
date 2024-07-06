return {
	{
		"ray-x/navigator.lua",
		dependencies = {
			{ "ray-x/guihua.lua",     build = "cd lua/fzy && make" },
			{ "neovim/nvim-lspconfig" },
		},
	},
	{
		"ray-x/go.nvim",
		dependencies = {
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
	"rakr/vim-one",
	"tpope/vim-obsession",
	"tpope/vim-repeat",
	"tpope/vim-surround",
	"lewis6991/gitsigns.nvim",
	"lukas-reineke/indent-blankline.nvim",
	"Lokaltog/vim-easymotion",
	"kdheepak/lazygit.nvim",
	"junegunn/vim-easy-align",
	{ "windwp/nvim-autopairs", event = "InsertEnter",        config = true },
	"nvim-treesitter/nvim-treesitter-context",
	{
		"L3MON4D3/LuaSnip",
		version = "*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		build = "make install_jsregexp",
	},
	"saadparwaiz1/cmp_luasnip",
	{
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	},
	{ "catppuccin/nvim",       name = "catppuccin" },
	{ "junegunn/fzf",          build = ":call fzf#install()" },
	{ "junegunn/fzf.vim" },
	"rafamadriz/friendly-snippets",
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},
	"tpope/vim-sleuth",
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},
	{ "VonHeikemen/fine-cmdline.nvim", dependencies = { { "MunifTanjim/nui.nvim" } } },
}
