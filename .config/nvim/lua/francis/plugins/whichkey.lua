-- Which Key: Shows a popup of available keybindings as you type leader keys.
-- Helps discover and remember keymaps. Activates after 500ms timeout.
return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    opts = {},
}
