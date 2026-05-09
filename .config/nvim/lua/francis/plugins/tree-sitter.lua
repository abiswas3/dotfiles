-- Treesitter (main-branch API): syntax highlighting, indent, textobjects via AST parsing.
-- Highlights and indent are wired per-buffer via vim.treesitter.start() in a FileType autocmd.
-- Textobjects: af/if (function), ac/ic (class), ]f/[f/]F/[F (move by function).
return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        lazy = false,
        build = ':TSUpdate',
        config = function()
            -- gitignore and dockerfile parsers are temporarily disabled: their upstream
            -- repos renamed master->main and nvim-treesitter's metadata still expects
            -- the master tarball, so install fails. Re-add once upstream is fixed.
            require('nvim-treesitter').install {
                'json', 'yaml', 'html', 'css',
                'markdown', 'markdown_inline',
                'lua', 'query',
                'rust', 'go', 'python', 'bash',
                'javascript', 'typescript', 'tsx',
                'toml', 'latex', 'bibtex', 'typst',
            }

            -- Use the bash parser for zsh files.
            vim.treesitter.language.register('bash', 'zsh')

            -- Enable highlights + indent on every buffer that has a parser available.
            vim.api.nvim_create_autocmd('FileType', {
                callback = function(ev)
                    local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
                    if not lang then return end
                    local ok = pcall(vim.treesitter.start, ev.buf, lang)
                    if ok then
                        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })

            -- Custom Pandoc fenced div highlighting for markdown (theorem environments).
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
        branch = 'main',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            local select = require 'nvim-treesitter-textobjects.select'
            local move = require 'nvim-treesitter-textobjects.move'

            vim.keymap.set({ 'x', 'o' }, 'af', function() select.select_textobject('@function.outer', 'textobjects') end, { desc = 'around function' })
            vim.keymap.set({ 'x', 'o' }, 'if', function() select.select_textobject('@function.inner', 'textobjects') end, { desc = 'inside function' })
            vim.keymap.set({ 'x', 'o' }, 'ac', function() select.select_textobject('@class.outer', 'textobjects') end, { desc = 'around class' })
            vim.keymap.set({ 'x', 'o' }, 'ic', function() select.select_textobject('@class.inner', 'textobjects') end, { desc = 'inside class' })

            vim.keymap.set({ 'n', 'x', 'o' }, ']f', function() move.goto_next_start('@function.outer', 'textobjects') end, { desc = 'next function start' })
            vim.keymap.set({ 'n', 'x', 'o' }, ']F', function() move.goto_next_end('@function.outer', 'textobjects') end, { desc = 'next function end' })
            vim.keymap.set({ 'n', 'x', 'o' }, '[f', function() move.goto_previous_start('@function.outer', 'textobjects') end, { desc = 'previous function start' })
            vim.keymap.set({ 'n', 'x', 'o' }, '[F', function() move.goto_previous_end('@function.outer', 'textobjects') end, { desc = 'previous function end' })
        end,
    },
}
