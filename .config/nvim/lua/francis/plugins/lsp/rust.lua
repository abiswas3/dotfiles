return {
    {
        'mrcjkb/rustaceanvim',
        version = '^5',
        lazy = false,
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

            if not codelldb:is_installed() then
                vim.notify('codelldb is not installed. Run :Mason to install it.', vim.log.levels.ERROR)
                return
            end

            local mason_path = vim.fn.stdpath 'data' .. '/mason/packages/codelldb'
            local extension_path = mason_path .. '/extension/'
            local codelldb_path = extension_path .. 'adapter/codelldb'
            local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'
            -- For Linux, adjust liblldb_path as needed

            local cfg = require 'rustaceanvim.config'

            -- vim.g.rustaceanvim = {
            --     dap = {
            --         adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
            --     },
            -- }
            vim.g.rustaceanvim = {
                dap = {
                    adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                },
                tools = {
                    autoSetHints = true,
                    inlay_hints = {
                        show_parameter_hints = true,
                        parameter_hints_prefix = 'in: ',
                        other_hints_prefix = 'out: ',
                    },
                },
                server = {
                    on_attach = function(client, bufnr)
                        -- Default LSP mappings (user can extend)
                        local function buf_set_keymap(...)
                            vim.api.nvim_buf_set_keymap(bufnr, ...)
                        end
                        local opts = { noremap = true, silent = true }
                        buf_set_keymap('n', 'K', '<Cmd>RustLsp hover actions<CR>', opts)
                        buf_set_keymap('n', '<leader>rr', '<Cmd>RustLsp runnables<CR>', opts)
                    end,
                    settings = {
                        ['rust-analyzer'] = {
                            assist = {
                                importEnforceGranularity = true,
                                importPrefix = 'create',
                            },
                            cargo = { allFeatures = true },
                            checkOnSave = {
                                command = 'clippy',
                                extraArgs = { '--all-features' },
                            },
                            -- checkOnSave = { command = 'clippy', allFeatures = true },
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

    'simrat39/symbols-outline.nvim',
    config = function()
        require('symbols-outline').setup {
            symbols = {
                File = { icon = 'F', hl = 'TSURI' },
                Module = { icon = 'M', hl = 'TSNamespace' },
                Namespace = { icon = 'N', hl = 'TSNamespace' },
                Package = { icon = 'P', hl = 'TSNamespace' },
                Class = { icon = 'C', hl = 'TSType' },
                Method = { icon = 'm', hl = 'TSMethod' },
                Property = { icon = 'p', hl = 'TSProperty' },
                Field = { icon = 'f', hl = 'TSField' },
                Constructor = { icon = 'c', hl = 'TSConstructor' },
                Enum = { icon = 'E', hl = 'TSEnum' },
                Interface = { icon = 'I', hl = 'TSInterface' },
                Function = { icon = 'f', hl = 'TSFunction' },
                Variable = { icon = 'v', hl = 'TSVariable' },
                Constant = { icon = 'k', hl = 'TSConstant' },
                String = { icon = 's', hl = 'TSString' },
                Number = { icon = '#', hl = 'TSNumber' },
                Boolean = { icon = 'b', hl = 'TSBoolean' },
                Array = { icon = 'a', hl = 'TSConstant' },
                Object = { icon = 'o', hl = 'TSType' },
                Key = { icon = 'k', hl = 'TSType' },
                Null = { icon = '0', hl = 'TSType' },
                EnumMember = { icon = 'e', hl = 'TSField' },
                Struct = { icon = 'S', hl = 'TSType' },
                Event = { icon = 'E', hl = 'TSType' },
                Operator = { icon = '+', hl = 'TSOperator' },
                TypeParameter = { icon = 'T', hl = 'TSParameter' },
            },
            show_symbol_details = false,
        }
    end,
    keys = {
        { '<leader>so', '<cmd>SymbolsOutline<cr>', desc = 'Symbols Outline' },
    },
    {
        'mfussenegger/nvim-dap',
        config = function()
            local dap, dapui = require 'dap', require 'dapui'
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
    {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
        config = function()
            require('dapui').setup()
        end,
    },
}
