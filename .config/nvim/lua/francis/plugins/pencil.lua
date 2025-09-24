return {
    -- other plugins
    {
        'preservim/vim-pencil',
        ft = { 'markdown', 'text', 'tex' }, -- only load for these filetypes
        init = function()
            -- optional: customize settings
            vim.g['pencil#wrapModeDefault'] = 'soft'
            vim.g['pencil#textwidth'] = 70 -- set line width
            vim.g['pencil#joinspaces'] = 1
        end,
    },
}
