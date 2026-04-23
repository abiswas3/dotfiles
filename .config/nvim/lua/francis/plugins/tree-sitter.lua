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

            -- nvim-treesitter master is unmaintained; on nvim 0.12 the directive
            -- signature changed so match[capture_id] is now TSNode[] instead of
            -- TSNode. The plugin's handlers pass that list into get_node_text,
            -- which crashes render-markdown.nvim. Re-register the three hit by
            -- markdown/HTML injection queries with compat-correct handlers.
            do
                local q = vim.treesitter.query
                local function first_node(match, id)
                    local v = match[id]
                    if type(v) == 'table' then return v[1] end
                    return v
                end

                local html_script_type_languages = {
                    importmap = 'json',
                    module = 'javascript',
                    ['application/ecmascript'] = 'javascript',
                    ['text/ecmascript'] = 'javascript',
                }
                local injection_aliases = {
                    ex = 'elixir', pl = 'perl', sh = 'bash', uxn = 'uxntal', ts = 'typescript',
                }
                local function lang_from_info_string(alias)
                    local m = vim.filetype.match { filename = 'a.' .. alias }
                    return m or injection_aliases[alias] or alias
                end

                q.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
                    local node = first_node(match, pred[2])
                    if not node then return end
                    local alias = vim.treesitter.get_node_text(node, bufnr):lower()
                    metadata['injection.language'] = lang_from_info_string(alias)
                end, { force = true })

                q.add_directive('set-lang-from-mimetype!', function(match, _, bufnr, pred, metadata)
                    local node = first_node(match, pred[2])
                    if not node then return end
                    local value = vim.treesitter.get_node_text(node, bufnr)
                    local configured = html_script_type_languages[value]
                    if configured then
                        metadata['injection.language'] = configured
                    else
                        local parts = vim.split(value, '/', {})
                        metadata['injection.language'] = parts[#parts]
                    end
                end, { force = true })

                q.add_directive('downcase!', function(match, _, bufnr, pred, metadata)
                    local id = pred[2]
                    local node = first_node(match, id)
                    if not node then return end
                    local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ''
                    metadata[id] = metadata[id] or {}
                    metadata[id].text = string.lower(text)
                end, { force = true })
            end

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
