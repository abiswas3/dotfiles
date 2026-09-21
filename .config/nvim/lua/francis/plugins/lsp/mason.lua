return {
    'williamboman/mason.nvim',
    dependencies = {
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        'neovim/nvim-lspconfig',
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
            -- Keep Mason limited to the explicitly supported non-Rust servers.
            -- Rust Analyzer is installed through Rustup and managed by Rustaceanvim.
            ensure_installed = {
                'lua_ls',
                'html',
                'tinymist',
            },
            automatic_enable = { 'lua_ls', 'html', 'tinymist' },
        }

        mason_tool_installer.setup {
            ensure_installed = {
                'prettier', -- prettier formatter
                'eslint_d',
            },
        }
    end,
}
