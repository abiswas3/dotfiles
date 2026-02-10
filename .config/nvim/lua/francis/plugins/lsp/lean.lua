-- Lean: Support for the Lean 4 theorem prover.
-- Provides LSP integration, goal view, and tactic suggestions.
return {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    ---@type lean.Config
    opts = {
        mappings = true,
    },
}
