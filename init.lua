local vimrc = vim.fn.stdpath("config") .. "/not-init.vim"
vim.cmd.source(vimrc)

require("plugins")
require("treesitter")

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})


require("catppuccin").setup({
    flavour = "mocha",
    coc_nvim = true,
    background = {
      light = "latte",
      dark = "mocha",
    },
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      telescope = true,
      notify = false,
      mini = false,
      coc_nvim = true,
    },
  })


require('lualine').setup{
  options = {
    theme = "catppuccin"
  }
}

require('gitsigns').setup()

require("ibl").setup()

require('nvim-web-devicons').setup {
 color_icons = true;
 default = true;
}

require("mason").setup()

require"fidget".setup{}
require("telescope").setup {
    defaults = {
      file_ignore_patterns = {
        "vendor/",
        "gen/"
    }
  }
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

-- Use Tab for trigger completion with characters ahead and navigate
-- NOTE: There's always a completion item selected by default, you may want to enable
-- no select by setting `"suggest.noselect": true` in your configuration file
-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- other plugins before putting this into your config
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "gr", "<Plug>(coc-references)", {silent = true})

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use <c-j> to trigger snippets
keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")


--- stuff --
-- Normal mode mappings
keyset('n', ']g', ':tabprevious<CR>')
keyset('n', '[g', ':tabnext<CR>')
keyset('n', 's', '<Plug>(easymotion-s2)')
keyset('n', 't', '<Plug>(easymotion-t2)')
keyset('n', '<leader>c', ':tabnew ~/.config/nvim/not-init.vim<CR>')
keyset('n', '<leader>nt', ':NvimTreeToggle<CR>')
keyset('n', '<leader>x', ':bd<CR>')
keyset('n', '<leader>ff', '<cmd>Telescope find_files<CR>')
keyset('n', '<leader>fg', '<cmd>Telescope live_grep<CR>')
keyset('n', '<leader>fb', '<cmd>Telescope buffers<CR>')
keyset('n', '<leader>gg', ':LazyGit<CR>', { silent = true })

-- Terminal mode mapping
keyset('t', '<Esc>', '<C-\\><C-n>')

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    command = ":silent call CocAction('runCommand', 'editor.action.organizeImport')"
})
