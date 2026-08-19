-- Colorschemes.  <leader>cs uses Telescope's built-in colorscheme picker.color

local function make_background_transparent()
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
end

return {
    -- Default colorscheme.
    -- Using Lazy
    {
        'navarasu/onedark.nvim',
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('onedark').setup {
                style = 'darker',
            }
            require('onedark').load()
        end,
    },
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('gruvbox').setup {
                contrast = 'hard',
                transparent_mode = true,
            }
        end,
    },

    {
        'catppuccin/nvim',
        name = 'catppuccin',
        lazy = false,
        priority = 1000,
        config = function()
            require('catppuccin').setup {
                transparent_background = true,
            }
        end,
    },
}
