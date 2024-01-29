vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'rakr/vim-one'
    use 'tmux-plugins/vim-tmux-focus-events'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-obsession'
    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'nvim-tree/nvim-tree.lua'
    use 'lewis6991/gitsigns.nvim'
    use 'lukas-reineke/indent-blankline.nvim'
    use 'Lokaltog/vim-easymotion'
    use 'kdheepak/lazygit.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'jodosha/vim-godebug'
    use 'junegunn/vim-easy-align'
    use 'nvim-tree/nvim-web-devicons'
    use 'nvim-lualine/lualine.nvim'
    use 'j-hui/fidget.nvim'
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'nvim-treesitter/nvim-treesitter-context'

    use({
        "L3MON4D3/LuaSnip",
        tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        run = "make install_jsregexp"
    })
    use "saadparwaiz1/cmp_luasnip"

    use {
        "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig"
    }

    use {"catppuccin/nvim", as = "catppuccin"}
    use {'junegunn/fzf', run = ":call fzf#install()"}
    use {'junegunn/fzf.vim'}
    use {
        'akinsho/bufferline.nvim',
        tag = "*",
        requires = 'nvim-tree/nvim-web-devicons'
    }

    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use "rafamadriz/friendly-snippets"
    use {'mhartington/formatter.nvim'}

    use {
        'goolord/alpha-nvim',
        requires = {'nvim-tree/nvim-web-devicons'},
        config = function()
            require'alpha'.setup(require'alpha.themes.startify'.config)
        end
    }
    use {
        'yanskun/gotests.nvim',
        ft = 'go',
        config = function() require('gotests').setup() end
    }
    use 'tpope/vim-sleuth'
    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {}
        end
    }
    use 'folke/neodev.nvim'
end)
