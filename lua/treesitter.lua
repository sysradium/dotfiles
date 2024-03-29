require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = {
        "go", "lua", "vim", "vimdoc", "python", "typescript", "javascript"
    },

    sync_install = false,
    auto_install = true,
    indent = {enable = true},
    highlight = {enable = true},
    additional_vim_regex_highlighting = false
}
