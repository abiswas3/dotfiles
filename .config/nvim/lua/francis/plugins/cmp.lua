-- nvim-cmp: Autocompletion engine.
-- Sources: LSP, snippets (LuaSnip), file paths, omni (VimTeX citations).
-- Tab/S-Tab navigate completions AND jump through snippet fields.
return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        'hrsh7th/cmp-path',     -- file system path completions
        'hrsh7th/cmp-omni',     -- VimTeX omni-completion (citations, refs)
        {
            'L3MON4D3/LuaSnip',
            version = 'v2.*',
            build = 'make install_jsregexp',
        },
        'saadparwaiz1/cmp_luasnip',   -- luasnip completion source
        'rafamadriz/friendly-snippets', -- community snippet library
        'onsails/lspkind.nvim',         -- VS Code-style icons in completion menu
    },
    config = function()
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        local lspkind = require 'lspkind'

        -- Load VS Code-style snippets from friendly-snippets
        require('luasnip.loaders.from_vscode').lazy_load()

        cmp.setup {
            completion = {
                completeopt = 'menu,menuone,preview,noselect',
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-k>'] = cmp.mapping.select_prev_item(),
                ['<C-j>'] = cmp.mapping.select_next_item(),
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm { select = false },
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },
            sources = cmp.config.sources {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'path' },
                {
                    name = 'omni',
                    option = {
                        disable_omnifuncs = { 'v:lua.vim.lsp.omnifunc' },
                    },
                },
            },
            formatting = {
                format = lspkind.cmp_format {
                    maxwidth = 50,
                    ellipsis_char = '...',
                },
            },
        }

        -- LaTeX files: prioritize omni-completion for \cite{} and \ref{}
        cmp.setup.filetype('tex', {
            sources = cmp.config.sources {
                { name = 'omni' },
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'path' },
            },
        })
    end,
}
