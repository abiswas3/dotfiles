-- Colorscheme: Install multiple themes, pick with <leader>cs via Telescope.
-- To add a new theme: add the plugin spec below AND an entry in the themes table.

-- All available themes and their setup. Each entry has:
--   colorscheme: the name passed to `vim.cmd.colorscheme()`
--   setup: optional function to call before applying (for plugin config)
local themes = {
    {
        name = 'OneDark Pro',
        colorscheme = 'onedark',
        setup = function()
            require('onedarkpro').setup { options = { transparency = true } }
        end,
    },
    {
        name = 'Gruvbox Dark Hard',
        colorscheme = 'gruvbox',
        setup = function()
            require('gruvbox').setup { contrast = 'hard', transparent_mode = true }
        end,
    },
    {
        name = 'Catppuccin Mocha',
        colorscheme = 'catppuccin-mocha',
        setup = function()
            require('catppuccin').setup { transparent_background = true }
        end,
    },
}

-- Default theme on startup (must match a `colorscheme` value above)
local default = 'onedark'

local function apply_theme(colorscheme)
    for _, t in ipairs(themes) do
        if t.colorscheme == colorscheme and t.setup then
            t.setup()
        end
    end
    vim.cmd.colorscheme(colorscheme)
    -- Force transparency regardless of theme
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
end

local function pick_theme()
    local pickers = require 'telescope.pickers'
    local finders = require 'telescope.finders'
    local conf = require('telescope.config').values
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'

    pickers
        .new({}, {
            prompt_title = 'Pick a Colorscheme',
            finder = finders.new_table {
                results = themes,
                entry_maker = function(entry)
                    return {
                        value = entry.colorscheme,
                        display = entry.name .. '  (' .. entry.colorscheme .. ')',
                        ordinal = entry.name,
                    }
                end,
            },
            sorter = conf.generic_sorter {},
            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    apply_theme(selection.value)
                end)
                return true
            end,
        })
        :find()
end

return {
    -- Theme plugins (all installed, only the default loads on startup)
    {
        'olimorris/onedarkpro.nvim',
        lazy = false,
        priority = 1000,
    },
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false,
        priority = 1000,
    },
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        lazy = false,
        priority = 1000,
    },
    -- Dummy spec to run startup config + register the keymap
    {
        'nvim-lua/plenary.nvim', -- already installed, just a hook to run config
        priority = 999,
        config = function()
            apply_theme(default)
            vim.keymap.set('n', '<leader>cs', pick_theme, { desc = 'Pick colorscheme' })
        end,
    },
}
