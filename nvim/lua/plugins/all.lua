return {
	-- {
	-- 	"ray-x/go.nvim",
	-- 	dependencies = {
	-- 		"ray-x/guihua.lua",
	-- 	},
	-- 	config = function()
	-- 		require("go").setup({
	-- 			lsp_inlay_hints = {
	-- 				enable = false,
	-- 			},
	-- 			lsp_document_formatting = false,
	-- 			null_ls = false,
	-- 			diagnostic = false,
	-- 			lsp_cfg = false,
	-- 		})
	-- 	end,
	-- 	event = { "CmdlineEnter" },
	-- 	ft = { "go", "gomod" },
	-- },
	"tpope/vim-repeat",
	"junegunn/vim-easy-align",
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},
}
