-- Indent Blankline: Shows thin vertical lines (┊) at each indentation level.
-- Helps visualize code nesting depth at a glance.
return {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    main = 'ibl',
    opts = {
        indent = { char = '┊' },
    },
}
