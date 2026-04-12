-- Treesitter: Syntax highlighting, indentation, and textobjects via AST parsing.
-- Textobjects: af/if (function), ac/ic (class), ]f/[f (move by function).
-- Custom: highlights Pandoc fenced divs (theorem, lemma, definition, etc.) in markdown.
return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        config = function()
            local parsers = {
                'json',
                'yaml',
                'html',
                'css',
                'markdown',
                'markdown_inline',
                'lua',
                'query',
                'dockerfile',
                'gitignore',
                'rust',
                'go',
                'python',
                'bash',
                'javascript',
                'typescript',
                'tsx',
                'toml',
                'latex',
                'bibtex',
                'typst',
            }

            require('nvim-treesitter.configs').setup {
                ensure_installed = parsers,
                highlight = { enable = true },
                indent = { enable = true },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner',
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = { [']f'] = '@function.outer' },
                        goto_next_end = { [']F'] = '@function.outer' },
                        goto_previous_start = { ['[f'] = '@function.outer' },
                        goto_previous_end = { ['[F'] = '@function.outer' },
                    },
                },
            }

            -- Use bash parser for zsh files
            vim.treesitter.language.register('bash', 'zsh')

            -- Custom Pandoc fenced div highlighting for markdown (theorem environments)
            local function setup_theorem_highlights()
                vim.api.nvim_set_hl(0, 'TheoremFence', { fg = '#C5050C', bg = '#FFE5E6', bold = true })
                vim.api.nvim_set_hl(0, 'LemmaFence', { fg = '#C5050C', bold = true })
                vim.api.nvim_set_hl(0, 'DefinitionFence', { fg = '#800408', bg = '#FFC2C4', bold = true })
                vim.api.nvim_set_hl(0, 'RemarkFence', { fg = '#800408', italic = true })
                vim.api.nvim_set_hl(0, 'QuestionFence', { fg = '#FFFFFF', bg = '#C5050C', bold = true })
                vim.api.nvim_set_hl(0, 'GoalFence', { fg = '#FFFFFF', bg = '#800408', bold = true })
            end

            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'markdown',
                callback = function()
                    setup_theorem_highlights()
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
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        event = { 'BufReadPre', 'BufNewFile' },
    },
}
