return {
    'williamboman/mason.nvim',
    dependencies = {
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        'neovim/nvim-lspconfig',
        {
            'chomosuke/typst-preview.nvim',
            ft = 'typst',
            version = '1.*',
            build = function()
                require('typst-preview').update()
            end,
        },
    },
    config = function()
        -- import mason
        local mason = require 'mason'

        -- import mason-lspconfig
        local mason_lspconfig = require 'mason-lspconfig'
        local mason_tool_installer = require 'mason-tool-installer'

        -- enable mason and configure icons
        mason.setup {
            ui = {
                icons = {
                    package_installed = '✓',
                    package_pending = '➜',
                    package_uninstalled = '✗',
                },
            },
        }

        mason_lspconfig.setup {
            -- list of servers for mason to install
            ensure_installed = {
                'ts_ls',
                'html',
                'cssls',
                -- "tailwindcss",
                -- "svelte",
                'lua_ls',
                'rust_analyzer',
                'tinymist',
                -- "graphql",
                -- "emmet_ls",
                -- "prismals",
            },
        }

        mason_tool_installer.setup {
            ensure_installed = {
                'prettier', -- prettier formatter
                'stylua', -- lua formatter
                'isort', -- python formatter
                'black', -- python formatter
                'pylint',
                'eslint_d',
            },
        }
    end,
}
