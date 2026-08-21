return {
    {
        'mrcjkb/rustaceanvim',
        version = '^9',
        ft = 'rust',
        config = function()
            local ok, mason_registry = pcall(require, 'mason-registry')
            if not ok then
                vim.notify('mason-registry not found', vim.log.levels.ERROR)
                return
            end

            local codelldb = mason_registry.get_package and mason_registry.get_package 'codelldb'
            if not codelldb then
                vim.notify('codelldb package not found in mason registry!', vim.log.levels.ERROR)
                return
            end

            local cfg = require 'rustaceanvim.config'
            local dap_config

            if codelldb:is_installed() then
                local mason_path = vim.fn.stdpath 'data' .. '/mason/packages/codelldb'
                local extension_path = mason_path .. '/extension/'
                local codelldb_path = extension_path .. 'adapter/codelldb'
                local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'

                dap_config = {
                    adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                }
            end

            vim.g.rustaceanvim = {
                dap = dap_config,
                tools = {
                    inlay_hints = {
                        show_parameter_hints = true,
                        parameter_hints_prefix = 'in: ',
                        other_hints_prefix = 'out: ',
                    },
                },
                server = {
                    cmd = { vim.fn.expand '~/.cargo/bin/rust-analyzer' },
                    capabilities = (function()
                        local caps = require('cmp_nvim_lsp').default_capabilities()
                        caps.general = caps.general or {}
                        caps.general.positionEncodings = { 'utf-16' }
                        return caps
                    end)(),
                    on_attach = function(client, bufnr)
                        -- semantic tokens re-enabled: colorscheme now defines @lsp.type.* groups
                        -- client.server_capabilities.semanticTokensProvider = nil
                        local function buf_set_keymap(...)
                            vim.api.nvim_buf_set_keymap(bufnr, ...)
                        end
                        local opts = { noremap = true, silent = true }
                        buf_set_keymap('n', 'K', '<Cmd>RustLsp hover actions<CR>', opts)
                        buf_set_keymap('n', '<leader>rr', '<Cmd>RustLsp runnables<CR>', opts)
                    end,
                    -- on_attach = function(client, bufnr)
                    --     -- Hand syntax highlighting back to tree-sitter:
                    --     -- rust-analyzer's semantic tokens overwrite TS highlights
                    --     -- with @lsp.type.* / @lsp.mod.* groups that most colorschemes
                    --     -- (onedarkpro included) don't style, which looks "washed out".
                    --     client.server_capabilities.semanticTokensProvider = nil
                    --
                    --     -- Default LSP mappings (user can extend)
                    --     local function buf_set_keymap(...)
                    --         vim.api.nvim_buf_set_keymap(bufnr, ...)
                    --     end
                    --     local opts = { noremap = true, silent = true }
                    --     buf_set_keymap('n', 'K', '<Cmd>RustLsp hover actions<CR>', opts)
                    --     buf_set_keymap('n', '<leader>rr', '<Cmd>RustLsp runnables<CR>', opts)
                    -- end,
                    settings = {
                        ['rust-analyzer'] = {
                            assist = {
                                importEnforceGranularity = true,
                                importPrefix = 'crate',
                            },
                            cargo = {
                                allFeatures = false,
                                -- Separate target dir so rust-analyzer doesn't invalidate `cargo build` cache.
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

    {
        'mfussenegger/nvim-dap',
    },
    {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
        config = function()
            local dap = require 'dap'
            local dapui = require 'dapui'
            dapui.setup()
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end,
    },
}
