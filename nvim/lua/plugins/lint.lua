return {
    "mfussenegger/nvim-lint",
    opts = {
        -- Event to trigger linters
        events = { "BufWritePost", "BufReadPost", "InsertLeave" },
        linters_by_ft = {
            fish = { "fish" },
            go = { "golangcilint" },
            -- Use the "*" filetype to run linters on all filetypes.
            -- ['*'] = { 'global linter' },
            -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
            -- ['_'] = { 'fallback linter' },
            -- ["*"] = { "typos" },
        },
        -- LazyVim extension to easily override linter options
        -- or add custom linters.
        ---@type table<string,table>
        linters = {
            golangcilint = {
                args = {
                    "run",
                    "--out-format",
                    "json",
                    "--show-stats=false",
                    "--print-issued-lines=false",
                    "--print-linter-name=false",
                    "--no-config",
                    "--disable=depguard",
                    function()
                        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
                    end,
                },
            },
            -- -- Example of using selene only when a selene.toml file is present
            -- selene = {
            --   -- `condition` is another LazyVim extension that allows you to
            --   -- dynamically enable/disable linters based on the context.
            --   condition = function(ctx)
            --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
            --   end,
            -- },
        },
    },
}
