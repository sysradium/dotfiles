vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'nvim-telescope/telescope.nvim'
	use 'rakr/vim-one'
	use 'sheerun/vim-polyglot'
	use 'tmux-plugins/vim-tmux-focus-events'
	use 'tpope/vim-fugitive'
	use 'tpope/vim-obsession'
	use 'tpope/vim-repeat'
	use 'tpope/vim-surround'
	use 'tpope/vim-unimpaired'
	use 'nvim-tree/nvim-tree.lua'
	use 'lewis6991/gitsigns.nvim'
	use 'lukas-reineke/indent-blankline.nvim'
	use 'Lokaltog/vim-easymotion'
	use 'kdheepak/lazygit.nvim'
	use 'nvim-lua/plenary.nvim'
	use 'honza/vim-snippets'
	use 'buoto/gotests-vim'
	use 'SirVer/ultisnips'
	use 'hynek/vim-python-pep8-indent'
	use 'jodosha/vim-godebug'
	use 'junegunn/vim-easy-align'
	use 'nvim-tree/nvim-web-devicons'
	use 'nvim-lualine/lualine.nvim'
	use 'j-hui/fidget.nvim'

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}

	use {
		'williamboman/mason.nvim', 
		run= ':MasonUpdate' 
	}

	use { "catppuccin/nvim", as = "catppuccin" }
	use { 'neoclide/coc.nvim', branch = 'release' }
	use { 'junegunn/fzf', run = ":call fzf#install()" }
	use { 'junegunn/fzf.vim' }
end)
