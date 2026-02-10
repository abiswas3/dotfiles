-- Aerial: Document symbol outline sidebar (functions, classes, methods, etc.)
-- <leader>so toggles the symbol outline panel.
return {
    'stevearc/aerial.nvim',
    opts = {},
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
    },
    keys = {
        { '<leader>so', '<cmd>AerialToggle!<CR>', desc = 'Aerial (Symbols)' },
    },
}
