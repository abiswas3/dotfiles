return {
    {
        'chomosuke/typst-preview.nvim',
        ft = 'typst',
        version = '1.*',
        build = function()
            require('typst-preview').update()
        end,
        config = function()
            require('typst-preview').setup {}
        end,
    },
    {
        'kaarmu/typst.vim',
        ft = 'typst',
        lazy = false,
    },
    {
        'al-kot/typst-preview.nvim',
        opts = {
            -- your config here
        },
    },
}
