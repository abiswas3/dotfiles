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

                opts.desc = 'Go to definition (first result)'
                keymap.set('n', 'gd', function()
                    -- Avoid the multi-result picker: dedupe locations and jump
                    -- straight to the first definition. rust-analyzer often returns
                    -- a (declaration, definition) pair for the same symbol.
                    vim.lsp.buf.definition {
                        on_list = function(o)
                            local items = o.items or {}
                            if #items == 0 then
                                return
                            end
                            local seen, deduped = {}, {}
                            for _, it in ipairs(items) do
                                local k = (it.filename or '') .. ':' .. tostring(it.lnum) .. ':' .. tostring(it.col)
                                if not seen[k] then
                                    seen[k] = true
                                    table.insert(deduped, it)
                                end
                            end
                            vim.cmd.edit(deduped[1].filename)
                            vim.api.nvim_win_set_cursor(0, { deduped[1].lnum, math.max(deduped[1].col - 1, 0) })
                        end,
                    }
                end, opts)
                opts.desc = 'Show all LSP definitions (picker)'
                keymap.set('n', '<leader>gd', '<cmd>Telescope lsp_definitions<CR>', opts) -- picker on demand

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
                    vim.diagnostic.jump { count = -1, float = true }
                end, opts)

                opts.desc = 'Go to next diagnostic'
                keymap.set('n', ']d', function()
                    vim.diagnostic.jump { count = 1, float = true }
                end, opts)

                opts.desc = 'Show documentation for what is under cursor'
                keymap.set('n', 'K', vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

                opts.desc = 'Restart LSP'
                keymap.set('n', '<leader>rs', '<cmd>lsp restart<CR>', opts) -- restart LSP clients
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
                ['harper-ls'] = {
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
                    diagnosticSeverity = 'hint',
                    dialect = 'British',
                },
            },
        })
        vim.lsp.enable 'harper_ls'
        vim.lsp.config('lua_ls', {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' },
                    },
                    workspace = {
                        checkThirdParty = false,
                    },
                },
            },
        })
        vim.lsp.config('tinymist', {
            on_attach = function(client, bufnr)
                vim.keymap.set('n', '<leader>tm', function()
                    client:exec_cmd({
                        title = 'pin',
                        command = 'tinymist.pinMain',
                        arguments = { vim.api.nvim_buf_get_name(0) },
                    }, { bufnr = bufnr })
                end, { buffer = bufnr, desc = 'Tinymist pin main file' })

                vim.keymap.set('n', '<leader>tu', function()
                    client:exec_cmd({
                        title = 'unpin',
                        command = 'tinymist.pinMain',
                        arguments = { vim.v.null },
                    }, { bufnr = bufnr })
                end, { buffer = bufnr, desc = 'Tinymist unpin main file' })
            end,
        })
    end,
}
