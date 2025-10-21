-- text completion
return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        -- "hrsh7th/cmp-buffer", -- source for text in buffer
        'hrsh7th/cmp-path', -- source for file system paths
        'hrsh7th/cmp-omni', -- LATEX: for VimTeX omni-completion (citations, refs, etc.)
        {
            'L3MON4D3/LuaSnip',
            -- follow latest release.
            version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            -- install jsregexp (optional!).
            build = 'make install_jsregexp',
        },
        'saadparwaiz1/cmp_luasnip', -- for autocompletion
        'rafamadriz/friendly-snippets', -- useful snippets
        'onsails/lspkind.nvim', -- vs-code like pictograms
    },
    config = function()
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        local lspkind = require 'lspkind'
        -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
        require('luasnip.loaders.from_vscode').lazy_load()

        cmp.setup {
            completion = {
                completeopt = 'menu,menuone,preview,noselect',
            },
            snippet = { -- configure how nvim-cmp interacts with snippet engine
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-k>'] = cmp.mapping.select_prev_item(), -- previous suggestion
                ['<C-j>'] = cmp.mapping.select_next_item(), -- next suggestion
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions
                ['<C-e>'] = cmp.mapping.abort(), -- close completion window
                ['<CR>'] = cmp.mapping.confirm { select = false },
                -- LATEX: Tab/S-Tab for snippet navigation (works better than C-l/C-h in LaTeX)
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
            -- sources for autocompletion
            sources = cmp.config.sources {
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- snippets
                -- { name = "buffer" }, -- text within current buffer
                { name = 'path' }, -- file system paths
                -- LATEX: omni-completion is LAST priority (only for \cite, \ref when VimTeX is loaded)
                {
                    name = 'omni',
                    option = {
                        disable_omnifuncs = { 'v:lua.vim.lsp.omnifunc' },
                    },
                },
            },
            -- configure lspkind for vs-code like pictograms in completion menu
            formatting = {
                format = lspkind.cmp_format {
                    maxwidth = 50,
                    ellipsis_char = '...',
                },
            },
        }

        -- LATEX: Special configuration for .tex files
        -- This prioritizes omni-completion for citations and references
        cmp.setup.filetype('tex', {
            sources = cmp.config.sources {
                { name = 'omni' }, -- VimTeX citations (\cite{}) and refs (\ref{})
                { name = 'nvim_lsp' }, -- Texlab LSP completions
                { name = 'luasnip' }, -- Snippets for fast environment creation
                { name = 'path' }, -- File paths for \input and \include
            },
        })
    end,
}
