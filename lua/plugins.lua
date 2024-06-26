return {
    -- 'wbthomason/packer.nvim',
    'nvim-telescope/telescope.nvim', 'rakr/vim-one', 'tpope/vim-fugitive',
    'tpope/vim-obsession', 'tpope/vim-repeat', 'tpope/vim-surround',
    'lewis6991/gitsigns.nvim', 'lukas-reineke/indent-blankline.nvim',
    'Lokaltog/vim-easymotion', 'kdheepak/lazygit.nvim', 'nvim-lua/plenary.nvim',
    'jodosha/vim-godebug', 'junegunn/vim-easy-align',
    'nvim-tree/nvim-web-devicons', 'j-hui/fidget.nvim',
    {'windwp/nvim-autopairs', event = "InsertEnter", config = true},
    {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
    'nvim-treesitter/nvim-treesitter-context', {
        'L3MON4D3/LuaSnip',
        version = '*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        build = 'make install_jsregexp'
    }, 'saadparwaiz1/cmp_luasnip', {
        'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig'
    }, {'catppuccin/nvim', name = 'catppuccin'},
    {'junegunn/fzf', build = ':call fzf#install()'}, {'junegunn/fzf.vim'},
    'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline', 'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp-signature-help', 'rafamadriz/friendly-snippets',
    {'mhartington/formatter.nvim'}, {
        'goolord/alpha-nvim',
        dependencies = {'nvim-tree/nvim-web-devicons'},
        config = function()
            require'alpha'.setup(require'alpha.themes.startify'.config)
        end
    }, 'tpope/vim-sleuth', {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {}
    }, 'folke/neodev.nvim', 'mfussenegger/nvim-lint',
    {'VonHeikemen/fine-cmdline.nvim', dependencies = {{'MunifTanjim/nui.nvim'}}},
    'rcarriga/nvim-notify', {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim", -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify"
        }
    }
}
