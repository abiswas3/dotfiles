return {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        { 'antosha417/nvim-lsp-file-operations', config = true },
        { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
        -- import cmp-nvim-lsp plugin
        local cmp_nvim_lsp = require 'cmp_nvim_lsp'

        local keymap = vim.keymap -- for conciseness
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf, silent = true }

                -- set keybinds
                opts.desc = 'Show LSP references'
                keymap.set('n', 'gR', '<cmd>Telescope lsp_references<CR>', opts) -- show definition, references

                opts.desc = 'Go to declaration'
                keymap.set('n', 'gD', vim.lsp.buf.declaration, opts) -- go to declaration

                opts.desc = 'Show LSP definitions'
                keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts) -- show lsp definitions

                opts.desc = 'Show LSP implementations'
                keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts) -- show lsp implementations

                opts.desc = 'Show LSP type definitions'
                keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>', opts) -- show lsp type definitions

                opts.desc = 'See available code actions'
                keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

                opts.desc = 'Smart rename'
                keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts) -- smart rename

                opts.desc = 'Show buffer diagnostics'
                keymap.set('n', '<leader>D', '<cmd>Telescope diagnostics bufnr=0<CR>', opts) -- show  diagnostics for file

                opts.desc = 'Show line diagnostics'
                keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts) -- show diagnostics for line

                opts.desc = 'Go to previous diagnostic'
                keymap.set('n', '[d', function()
                    vim.diagnostic.jump({ count = -1, float = true })
                end, opts)

                opts.desc = 'Go to next diagnostic'
                keymap.set('n', ']d', function()
                    vim.diagnostic.jump({ count = 1, float = true })
                end, opts)

                opts.desc = 'Show documentation for what is under cursor'
                keymap.set('n', 'K', vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

                opts.desc = 'Restart LSP'
                keymap.set('n', '<leader>rs', ':LspRestart<CR>', opts) -- mapping to restart lsp if necessary
            end,
        })

        local capabilities = cmp_nvim_lsp.default_capabilities()
        capabilities.general = capabilities.general or {}
        capabilities.general.positionEncodings = { 'utf-16' }

        vim.diagnostic.config {
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = ' ',
                    [vim.diagnostic.severity.WARN] = ' ',
                    [vim.diagnostic.severity.HINT] = '󰠠 ',
                    [vim.diagnostic.severity.INFO] = ' ',
                },
            },
        }

        vim.lsp.config('*', {
            capabilities = capabilities,
        })

        -- Disable native rust_analyzer — rustaceanvim manages it.
        -- Must be called here (after lspconfig registers the config) to stick.
        vim.lsp.enable('rust_analyzer', false)

        -- Add texlab for LaTeX support in Markdown
        vim.lsp.config('texlab', {
            filetypes = { 'tex', 'plaintex', 'bib', 'markdown' },
            settings = {
                texlab = {
                    auxDirectory = '.',
                    bibtexFormatter = 'texlab',
                    build = {
                        executable = 'latexmk',
                        args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
                        onSave = false,
                    },
                    chktex = {
                        onEdit = false,
                        onOpenAndSave = false,
                    },
                },
            },
        })
        vim.lsp.config('harper_ls', {
          filetypes = { 'markdown' },
          settings = {
            ["harper-ls"] = {
              linters = {
                SpellCheck = true,
                SpelledNumbers = false,
                AnA = true,
                SentenceCapitalization = true,
                UnclosedQuotes = true,
                WrongQuotes = false,
                LongSentences = true,
                RepeatedWords = true,
                Spaces = true,
                Matcher = true,
                CorrectNumberSuffix = true,
              },
              diagnosticSeverity = "hint",
              dialect = "American",
            },
          },
        })
        vim.lsp.enable('harper_ls')

        -- Go LSP
        vim.lsp.config('gopls', {
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                        infertypeargs = false,
                    },
                    hints = {
                        assignVariableTypes = false,
                        compositeLiteralFields = false,
                        compositeLiteralTypes = false,
                        constantValues = false,
                        functionTypeParameters = false,
                        parameterNames = false,
                        rangeVariableTypes = false,
                    },
                    staticcheck = true,
                    gofumpt = true,
                },
            },
        })
        vim.lsp.enable('gopls')
    end,
}
