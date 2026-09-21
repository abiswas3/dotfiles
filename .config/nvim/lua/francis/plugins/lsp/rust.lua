return {
    {
        'mrcjkb/rustaceanvim',
        version = '^9',
        -- Rustaceanvim manages its own filetype loading.  Its configuration
        -- must be available before the plugin is initialised.
        lazy = false,
        init = function()
            vim.g.rustaceanvim = function()
                local capabilities = require('cmp_nvim_lsp').default_capabilities()
                capabilities.general = capabilities.general or {}
                capabilities.general.positionEncodings = { 'utf-16' }

                return {
                    tools = {
                        inlay_hints = {
                            show_parameter_hints = true,
                            parameter_hints_prefix = 'in: ',
                            other_hints_prefix = 'out: ',
                        },
                    },
                    server = {
                        -- Use the Rustup component directly.  This avoids
                        -- Mason's copy drifting from the active Rust toolchain.
                        cmd = { vim.fn.expand '~/.cargo/bin/rust-analyzer' },
                        capabilities = capabilities,
                        on_attach = function(_, bufnr)
                            vim.keymap.set('n', 'K', '<Cmd>RustLsp hover actions<CR>',
                                { buffer = bufnr, noremap = true, silent = true })
                            vim.keymap.set('n', '<leader>rr', '<Cmd>RustLsp runnables<CR>',
                                { buffer = bufnr, noremap = true, silent = true })
                        end,
                        default_settings = {
                            ['rust-analyzer'] = {
                                assist = {
                                    importEnforceGranularity = true,
                                    importPrefix = 'crate',
                                },
                                cargo = {
                                    allFeatures = false,
                                    -- Keep Rust Analyzer from invalidating the normal Cargo build cache.
                                    targetDir = true,
                                },
                                files = {
                                    watcher = 'server',
                                },
                                procMacro = { enable = true },
                                check = {
                                    command = 'clippy',
                                },
                                inlayHints = {
                                    lifetimeElisionHints = { enable = true, useParameterNames = true },
                                },
                            },
                        },
                    },
                }
            end
        end,
    },
    {
        'rust-lang/rust.vim',
        ft = 'rust',
        init = function()
            vim.g.rustfmt_autosave = 1
        end,
    },
    {
        'saecki/crates.nvim',
        ft = { 'toml' },
        config = function()
            require('crates').setup {
                completion = {
                    cmp = { enabled = true },
                },
            }
            require('cmp').setup.buffer {
                sources = { { name = 'crates' } },
            }
        end,
    },
}
