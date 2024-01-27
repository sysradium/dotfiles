local vimrc = vim.fn.stdpath("config") .. "/not-init.vim"
vim.cmd.source(vimrc)

require("plugins")
require("treesitter")
require("lsp_config")
require("formatting")

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
vim.cmd.colorscheme "catppuccin-mocha"

require("catppuccin").setup({
    flavour = "mocha",
    background = {light = "latte", dark = "mocha"},
    indent_blankline = {enabled = true, colored_indent_levels = false},
    integrations = {
        alpha = true,
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = true,
        treesitter_context = true,
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = {"italic"},
                hints = {"italic"},
                warnings = {"italic"},
                information = {"italic"}
            },
            underlines = {
                errors = {"underline"},
                hints = {"underline"},
                warnings = {"underline"},
                information = {"underline"}
            },
            inlay_hints = {background = true}
        }
    }
})

local mocha = require("catppuccin.palettes").get_palette "mocha"
require("bufferline").setup {
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

require'treesitter-context'.setup {}
require('lualine').setup {options = {theme = "catppuccin"}}
require('gitsigns').setup()
require("ibl").setup()
require('nvim-web-devicons').setup {color_icons = true, default = true}
require"fidget".setup {}
require("telescope").setup {
    defaults = {file_ignore_patterns = {"vendor/", "gen/"}}
}

-- #### coc-nvim

-- Some servers have issues with backup files, see #649
vim.opt.backup = false
vim.opt.writebackup = false

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
vim.opt.updatetime = 300

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appeared/became resolved
vim.opt.signcolumn = "yes"

local keyset = vim.keymap.set
-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

--- stuff --
-- Normal mode mappings
keyset('n', ']g', ':bn<CR>')
keyset('n', '[g', ':bp<CR>')
keyset('n', 's', '<Plug>(easymotion-s2)')
keyset('n', 't', '<Plug>(easymotion-t2)')
keyset('n', '<leader>c', ':tabnew ~/.config/nvim/not-init.vim<CR>')
keyset('n', '<leader>nt', ':NvimTreeToggle<CR>')
keyset('n', '<leader>x', ':bd<CR>')
keyset('n', '<leader>ff', '<cmd>Telescope find_files<CR>')
keyset('n', '<leader>fg', '<cmd>Telescope live_grep<CR>')
keyset('n', '<leader>fb', '<cmd>Telescope buffers<CR>')
keyset('n', '<leader>gg', ':LazyGit<CR>', {silent = true})

-- Terminal mode mapping
keyset('t', '<Esc>', '<C-\\><C-n>')
