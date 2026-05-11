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
            -- list of servers for mason to install
            ensure_installed = {
                'html',
                -- "tailwindcss",
                -- "svelte",
                -- rust_analyzer is managed by rustaceanvim, not mason
                'tinymist',
                'harper_ls',
                'gopls',
                -- "graphql",
                -- "emmet_ls",
                -- "prismals",
            },
        }

        mason_tool_installer.setup {
            ensure_installed = {
                'prettier', -- prettier formatter
                'stylua', -- lua formatter
                'eslint_d',
                'goimports', -- go import organizer
            },
        }
    end,
}
