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
                            -- ['af'] = '@function.outer',
                            ['af'] = '@block.outer',
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

            -- Custom theorem environment highlighting for Markdown
            local function setup_theorem_highlights()
                -- Define Badgers red color scheme
                vim.api.nvim_set_hl(0, 'TheoremFence', { fg = '#C5050C', bg = '#FFE5E6', bold = true })
                vim.api.nvim_set_hl(0, 'LemmaFence', { fg = '#C5050C', bold = true })
                vim.api.nvim_set_hl(0, 'DefinitionFence', { fg = '#800408', bg = '#FFC2C4', bold = true })
                vim.api.nvim_set_hl(0, 'RemarkFence', { fg = '#800408', italic = true })
                vim.api.nvim_set_hl(0, 'QuestionFence', { fg = '#FFFFFF', bg = '#C5050C', bold = true })
                vim.api.nvim_set_hl(0, 'GoalFence', { fg = '#FFFFFF', bg = '#800408', bold = true })
            end

            -- Set up syntax matching for markdown files
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'markdown',
                callback = function()
                    setup_theorem_highlights()

                    -- Define syntax matches for fenced divs
                    vim.cmd [[
                        syntax match TheoremDiv /^:::\s*{\.theorem\(\s.*\)\?}.*$/ 
                        syntax match LemmaDiv /^:::\s*{\.lemma\(\s.*\)\?}.*$/
                        syntax match CorollaryDiv /^:::\s*{\.corollary\(\s.*\)\?}.*$/
                        syntax match PropositionDiv /^:::\s*{\.proposition\(\s.*\)\?}.*$/
                        syntax match DefinitionDiv /^:::\s*{\.definition\(\s.*\)\?}.*$/
                        syntax match ClaimDiv /^:::\s*{\.claim\(\s.*\)\?}.*$/
                        syntax match RemarkDiv /^:::\s*{\.remark\(\s.*\)\?}.*$/
                        syntax match ProofDiv /^:::\s*{\.proof\(\s.*\)\?}.*$/
                        syntax match QuestionDiv /^:::\s*{\.question\(\s.*\)\?}.*$/
                        syntax match ProblemDiv /^:::\s*{\.problem\(\s.*\)\?}.*$/
                        syntax match GoalDiv /^:::\s*{\.goal\(\s.*\)\?}.*$/
                        syntax match FencedDivEnd /^:::$/
                        
                        highlight link TheoremDiv TheoremFence
                        highlight link LemmaDiv LemmaFence
                        highlight link CorollaryDiv LemmaFence
                        highlight link PropositionDiv LemmaFence
                        highlight link DefinitionDiv DefinitionFence
                        highlight link ClaimDiv DefinitionFence
                        highlight link RemarkDiv RemarkFence
                        highlight link ProofDiv RemarkFence
                        highlight link QuestionDiv QuestionFence
                        highlight link ProblemDiv QuestionFence
                        highlight link GoalDiv GoalFence
                        highlight link FencedDivEnd TheoremFence
                    ]]
                end,
            })
        end,
    },
    -- Treesitter textobjects plugin (required for the above to work)
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        event = { 'BufReadPre', 'BufNewFile' },
    },
}
