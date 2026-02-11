-- Python & Go development support.
-- Neogen: Docstring generation (numpydoc for Python, godoc for Go).
--   <Leader>ld generate docstring, <Leader>gf function doc, <Leader>gc class doc.
-- vim-go: Go tooling (auto-format with goimports on save).
return {
    {
        'danymat/neogen',
        dependencies = 'nvim-treesitter/nvim-treesitter',
        config = function()
            require('neogen').setup {
                enabled = true,
                snippet_engine = 'luasnip',
                languages = {
                    python = { template = { annotation_convention = 'numpydoc' } },
                    go = { template = { annotation_convention = 'godoc' } },
                },
            }
        end,
        keys = {
            {
                '<Leader>ld',
                function()
                    require('neogen').generate()
                end,
                desc = 'Generate docstring',
            },
            {
                '<Leader>gf',
                function()
                    require('neogen').generate { type = 'func' }
                end,
                desc = 'Function docstring',
            },
            {
                '<Leader>gc',
                function()
                    require('neogen').generate { type = 'class' }
                end,
                desc = 'Class docstring',
            },
        },
    },
    {
        'fatih/vim-go',
        ft = 'go',
        build = ':GoUpdateBinaries',
        config = function()
            vim.g.go_fmt_autosave = 1
            vim.g.go_fmt_command = 'goimports'
        end,
    },
}
