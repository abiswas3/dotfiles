return {
    -- Core Treesitter plugin
    {
        'nvim-treesitter/nvim-treesitter',
        event = { 'BufReadPre', 'BufNewFile' },
        build = ':TSUpdate',
        config = function()
            local ts = require 'nvim-treesitter.configs'

            ts.setup {
                ensure_installed = {
                    'json',
                    'yaml',
                    'html',
                    'css',
                    'markdown',
                    'markdown_inline',
                    'lua',
                    'vim',
                    'dockerfile',
                    'gitignore',
                    'query',
                    'vimdoc',
                    'c',
                    'rust',
                    'go',
                },
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<C-space>',
                        node_incremental = '<C-space>',
                        scope_incremental = false,
                        node_decremental = '<bs>',
                    },
                },
                textobjects = {
                    move = {
                        enable = true,
                        set_jumps = true, -- add jumps to jumplist
                        goto_next_start = {
                            [']f'] = '@function.outer',
                        },
                        goto_next_end = {
                            [']F'] = '@function.outer',
                        },
                        goto_previous_start = {
                            ['[f'] = '@function.outer',
                        },
                        goto_previous_end = {
                            ['[F'] = '@function.outer',
                        },
                    },
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
                            ['as'] = { query = '@local.scope', query_group = 'locals', desc = 'Select language scope' },
                        },
                        selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'V', -- linewise
                            ['@class.outer'] = '<c-v>', -- blockwise
                        },
                        include_surrounding_whitespace = true,
                    },
                },
            }

            -- use bash parser for zsh files
            vim.treesitter.language.register('bash', 'zsh')
        end,
    },

    -- Treesitter textobjects plugin (required for the above to work)
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        event = { 'BufReadPre', 'BufNewFile' },
    },
}
