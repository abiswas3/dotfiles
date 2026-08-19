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
            require('typst-preview').setup {
                invert_colors = 'false',
                debug = true,
            }

            -- Typst preview keymaps (buffer-local to typst files)
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'typst',
                callback = function(ev)
                    local buf = ev.buf
                    vim.keymap.set('n', '<leader>ts', function()
                        require('typst-preview').start()
                    end, { buffer = buf, desc = 'Start Typst preview' })

                    vim.keymap.set('n', '<leader>tq', function()
                        require('typst-preview').stop()
                    end, { buffer = buf, desc = 'Stop Typst preview' })

                    vim.keymap.set('n', '<leader>tn', function()
                        require('typst-preview').next_page()
                    end, { buffer = buf, desc = 'Typst next page' })

                    vim.keymap.set('n', '<leader>tp', function()
                        require('typst-preview').prev_page()
                    end, { buffer = buf, desc = 'Typst previous page' })

                    vim.keymap.set('n', '<leader>tr', function()
                        require('typst-preview').refresh()
                    end, { buffer = buf, desc = 'Refresh preview' })

                    vim.keymap.set('n', '<leader>tgg', function()
                        require('typst-preview').first_page()
                    end, { buffer = buf, desc = 'First page' })

                    vim.keymap.set('n', '<leader>tG', function()
                        require('typst-preview').last_page()
                    end, { buffer = buf, desc = 'Last page' })
                end,
            })
        end,
    },
    {
        'kaarmu/typst.vim',
        ft = 'typst',
    },
}
