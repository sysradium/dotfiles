local vimrc = vim.fn.stdpath("config") .. "/not-init.vim"
vim.cmd.source(vimrc)


-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
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
    telescope = true,
    notify = false,
    mini = false,
  },
})

require('gitsigns').setup()

require("indent_blankline").setup {
    show_end_of_line = false,
    show_current_context = true,
    show_current_context_start = false,
}

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

