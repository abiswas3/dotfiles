-- Zen Mode: Distraction-free writing mode that centers the buffer and dims surroundings.
-- Pairs with Pencil for a full writing environment via <leader>pp.
return {
    'folke/zen-mode.nvim',
    opts = {
        plugins = {
            twilight = { enabled = true }, -- dim inactive code with Twilight
        },
    },
}
