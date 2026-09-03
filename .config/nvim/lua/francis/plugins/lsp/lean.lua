-- Lean: Support for the Lean 4 theorem prover.
-- Provides LSP integration, goal view, and tactic suggestions.
-- Lean: Support for the Lean 4 theorem prover.
-- Provides LSP integration, goal view, and tactic suggestions.
return {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
    dependencies = {
        'nvim-lua/plenary.nvim',
        'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        capabilities.general = capabilities.general or {}
        capabilities.general.positionEncodings = { 'utf-16' }
        capabilities.workspace = capabilities.workspace or {}
        capabilities.workspace.didChangeWatchedFiles = {
            dynamicRegistration = false,
        }

        vim.lsp.config('leanls', {
            capabilities = capabilities,
        })

        -- Set configuration via vim.g.lean_config instead of require('lean').setup()
        vim.g.lean_config = {
            mappings = true,
            lsp = {
                enable = true,
                enhanced_handlers = {
                    diagnostics = true,
                    hover = true,
                },
            },
            infoview = {
                orientation = 'vertical',
            },
        }
    end,
}
