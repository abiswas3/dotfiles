-- Typst support: Live preview and syntax highlighting for .typst files.
-- typst-preview.nvim provides browser-based live preview.
-- typst.vim adds syntax highlighting and filetype detection.
-- Keymaps (set in options.lua): <leader>ts start, <leader>tq stop,
-- <leader>tn/tp next/prev page.
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

            -- Typst preview keymaps
            vim.keymap.set('n', '<leader>ts', function()
                require('typst-preview').start()
            end, { desc = 'Start Typst preview' })

            vim.keymap.set('n', '<leader>tq', function()
                require('typst-preview').stop()
            end, { desc = 'Stop Typst preview' })

            vim.keymap.set('n', '<leader>tn', function()
                require('typst-preview').next_page()
            end, { desc = 'Next page' })

            vim.keymap.set('n', '<leader>tp', function()
                require('typst-preview').prev_page()
            end, { desc = 'Previous page' })

            vim.keymap.set('n', '<leader>tr', function()
                require('typst-preview').refresh()
            end, { desc = 'Refresh preview' })

            vim.keymap.set('n', '<leader>tgg', function()
                require('typst-preview').first_page()
            end, { desc = 'First page' })

            vim.keymap.set('n', '<leader>tG', function()
                require('typst-preview').last_page()
            end, { desc = 'Last page' })
        end,
    },
    {
        'kaarmu/typst.vim',
        ft = 'typst',
    },
}
