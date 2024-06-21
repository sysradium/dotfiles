require("plugins")
require("treesitter")
require("lsp_config")
require("formatting")
require("colorscheme")

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

local mocha = require("catppuccin.palettes").get_palette "mocha"
require("bufferline").setup {
    options = {diagnostics = "nvim_lsp"},
    highlights = require("catppuccin.groups.integrations.bufferline").get {
        styles = {"italic", "bold"},
        custom = {
            all = {fill = {bg = "#000000"}},
            mocha = {background = {fg = mocha.text}},
            latte = {background = {fg = "#000000"}}
        }
    }
}

-- empty setup using defaults
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {width = 30},
    renderer = {group_empty = true},
    filters = {dotfiles = false}
})

require('treesitter-context').setup {}
require('lualine').setup {options = {theme = "catppuccin"}}
require('gitsigns').setup()
require("ibl").setup()
require('nvim-web-devicons').setup {color_icons = true, default = true}
require"fidget".setup {}
require("telescope").setup {
    defaults = {file_ignore_patterns = {"vendor/", "gen/"}}
}
pcall(require('telescope').load_extension, 'fzf')

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
