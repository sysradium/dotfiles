require("mason").setup()
require("mason-lspconfig").setup()

local luasnip = require('luasnip')
local cmp = require 'cmp'
local select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup {
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
    },
    formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = 'λ',
                luasnip = '⋗',
                buffer = 'Ω',
                path = '🖫'
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end
    },
    snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping(function(fallback)
            local col = vim.fn.col('.') - 1
            if cmp.visible() then
                cmp.select_next_item(select_opts)
            elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                fallback()
            else
                cmp.complete()
            end
        end, {'i', 's'}),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item(select_opts)
            else
                fallback()
            end
        end, {'i', 's'}),
        ['<C-f>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, {'i', 's'}),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({select = false}) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = {
        {name = 'nvim_lsp_signature_help'},
        {name = 'nvim_lsp', keyword_length = 1},
        {name = 'buffer', keyword_length = 3},
        {name = 'luasnip', keyword_length = 2}
    }
}

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = {buffer = ev.buf}
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder,
                       opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({'n', 'v'}, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f',
                       function() vim.lsp.buf.format {async = true} end, opts)
    end
})

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')
lspconfig.pyright.setup {capabilities = capabilities}
lspconfig.tsserver.setup {capabilities = capabilities}
lspconfig.gopls.setup {capabilities = capabilities}

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

require("luasnip.loaders.from_vscode").load({include = {"go"}})

vim.lsp.handlers['textDocument/hover'] =
    vim.lsp.with(vim.lsp.handlers.hover, {border = 'rounded'})

vim.lsp.handlers['textDocument/signatureHelp'] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {border = 'rounded'})
