-- Using Lazy
return {
    'olimorris/onedarkpro.nvim',
    priority = 1000,
    config = function()
        require('onedarkpro').setup {
            options = {
                transparency = true,
            },
        }
        vim.cmd 'colorscheme onedark'

        -- Make sure transparency works
        vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
    end,
}
-- return {
--     'navarasu/onedark.nvim',
--     priority = 1000, -- make sure to load this before all the other start plugins
--     config = function()
--         require('onedark').setup {
--             style = 'warmer',
--             colors = {
--                 bright_orange = '#ff8800', -- define a new color
--                 green = '#00ffaa', -- redefine an existing color
--             },
--             --      highlights = {
--             --       ["@lsp.type.keyword"] = { fg = "$green" },
--             --   ["@lsp.type.property"] = {fg = '$bright_orange', bg = '#00ff00', fmt = 'bold'},
--             --   ["@lsp.type.function"] =  {fg = '#0000ff', sp = '$cyan', fmt = 'underline,italic'},
--             --   ["@lsp.type.method"] = { link = "@function" },
--             -- -- To add language specific config
--             --   ["@lsp.type.variable.go"] = { fg = "none" },
--             --   },
--         }
--         -- Enable theme
--         require('onedark').load()
--         vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
--         vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
--         vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
--         vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
--     end,
-- }
