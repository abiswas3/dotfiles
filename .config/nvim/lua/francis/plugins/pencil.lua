-- Vim Pencil: Soft line wrapping for prose/writing modes.
-- Loads for markdown, text, tex, typst. Wraps at 70 chars.
-- Used together with ZenMode via <leader>pp.
return {
    {
        'preservim/vim-pencil',
        ft = { 'markdown', 'text', 'tex', 'typst' },
        init = function()
            vim.g['pencil#wrapModeDefault'] = 'soft'
            vim.g['pencil#textwidth'] = 70
            vim.g['pencil#joinspaces'] = 1
        end,
    },
}
