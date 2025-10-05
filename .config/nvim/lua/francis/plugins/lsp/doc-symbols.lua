return -- Add to your plugins
{
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
