-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require("config.lazy")
require("plugins")
require("treesitter")
require("lsp_config")
require("formatting")
require("colorscheme")

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "120"
vim.o.mouse = 'a'
vim.o.breakindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.completeopt = 'menuone,noselect'

require('treesitter-context').setup {}
require('gitsigns').setup()
require("ibl").setup()
require('nvim-web-devicons').setup {color_icons = true, default = true}
require"fidget".setup {}
require("telescope").setup {
    defaults = {file_ignore_patterns = {"vendor/", "gen/"}}
}
pcall(require('telescope').load_extension, 'fzf')
require'navigator'.setup()
-- Some servers have issues with backup files, see #649
vim.opt.backup = false
vim.opt.writebackup = false

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
vim.opt.updatetime = 80

local keyset = vim.keymap.set
-- Normal mode mappings
keyset('n', ']q', ':cnext<CR>')
keyset('n', '[q', ':cprev<CR>')
keyset('n', ']b', ':bn<CR>')
keyset('n', '[b', ':bp<CR>')
keyset('n', 's', '<Plug>(easymotion-s2)')
keyset('n', 't', '<Plug>(easymotion-t2)')
keyset('n', '<leader>nt', ':NvimTreeToggle<CR>')
keyset('n', '<leader>x', ':bd<CR>')
keyset('n', '<leader>ff', '<cmd>Telescope find_files<CR>')
keyset('n', '<leader>fg', '<cmd>Telescope live_grep<CR>')
keyset('n', '<leader>fb', '<cmd>Telescope buffers<CR>')
keyset('n', '<leader>gg', ':LazyGit<CR>', {silent = true})

-- Terminal mode mapping
keyset('t', '<Esc>', '<C-\\><C-n>')

local highlight_group = vim.api.nvim_create_augroup('YankHighlight',
                                                    {clear = true})
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function() vim.highlight.on_yank() end,
    group = highlight_group,
    pattern = '*'
})

require('lint').linters_by_ft = {go = {'golangcilint'}}
vim.api.nvim_create_autocmd({"BufWritePost"}, {
    callback = function() require("lint").try_lint() end
})
require("notify").setup({background_colour = "#000000"})
require("noice").setup({
    lsp = {hover = {enabled = false}},
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
            position = {row = 27, col = "50%"},
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
