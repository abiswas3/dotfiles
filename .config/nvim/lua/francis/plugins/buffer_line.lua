-- Bufferline: Shows open tabs as a VS Code-style tab bar at the top.
-- Mode is set to 'tabs' (one tab per vim tab, not per buffer).
return {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    version = '*',
    opts = {
        options = {
            mode = 'tabs',
        },
    },
}
