-- Substitute: Replace text using motions (like a "paste-over" operator).
-- <leader>r{motion} substitutes the motion target with register contents.
-- <leader>rr substitutes entire line, <leader>R to end of line.
return {
    'gbprod/substitute.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        local substitute = require 'substitute'
        substitute.setup()

        local keymap = vim.keymap
        keymap.set('n', '<leader>r', substitute.operator, { desc = 'Substitute with motion' })
        keymap.set('n', '<leader>rr', substitute.line, { desc = 'Substitute line' })
        keymap.set('n', '<leader>R', substitute.eol, { desc = 'Substitute to end of line' })
        keymap.set('x', '<leader>r', substitute.visual, { desc = 'Substitute in visual mode' })
    end,
}
