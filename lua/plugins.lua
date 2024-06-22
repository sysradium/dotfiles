vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'rakr/vim-one'
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
        'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup {} end
    }

    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'nvim-treesitter/nvim-treesitter-context'

    use({
        'L3MON4D3/LuaSnip',
        tag = '*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        run = 'make install_jsregexp'
    })
    use 'saadparwaiz1/cmp_luasnip'

    use {
        'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig'
    }

    use {'catppuccin/nvim', as = 'catppuccin'}
    use {'junegunn/fzf', run = ':call fzf#install()'}
    use {'junegunn/fzf.vim'}
    use {
        'akinsho/bufferline.nvim',
        tag = '*',
        requires = 'nvim-tree/nvim-web-devicons'
    }

    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'rafamadriz/friendly-snippets'
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
        'folke/which-key.nvim',
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require('which-key').setup {}
        end
    }
    use 'folke/neodev.nvim'
    use 'mfussenegger/nvim-lint'
    require('lint').linters_by_ft = {go = {'golangcilint'}}

    vim.api.nvim_create_autocmd({"BufWritePost"}, {
        callback = function() require("lint").try_lint() end
    })

    use {'VonHeikemen/fine-cmdline.nvim', requires = {{'MunifTanjim/nui.nvim'}}}
    use {'folke/noice.nvim', rqeuires = {{'MunifTanjim/nui.nvim'}}}
    require("noice").setup({
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true -- requires hrsh7th/nvim-cmp
            }
        },
        views = {
            cmdline_popup = {
                border = {style = "rounded", padding = {0, 0}},
                filter_options = {},
                position = {row = 17, col = "50%"},
                size = {width = 60},
                win_options = {
                    winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder"
                }
            },
            popupmenu = {
                relative = "editor",
                position = {row = 20, col = "50%"},
                size = {width = 60, height = 10},
                border = {style = "rounded", padding = {0, 0}},
                win_options = {
                    winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder"
                }
            },
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false -- add a border to hover docs and signature help
            }
        }
    })
    use 'rcarriga/nvim-notify'
    require("notify").setup({background_colour = "#0000000"})
end)
