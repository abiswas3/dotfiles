-- Vim Maximizer: Toggle maximize/restore for the current split window.
-- <leader>sm to toggle. Useful when you have multiple splits but want to
-- temporarily focus on one.
return {
    'szw/vim-maximizer',
    keys = {
        { '<leader>sm', '<cmd>MaximizerToggle<CR>', desc = 'Maximize/minimize a split' },
    },
}
