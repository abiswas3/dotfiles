return {
    {
        'folke/todo-comments.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local todo_comments = require 'todo-comments'

            -- set keymaps
            local keymap = vim.keymap -- for conciseness

            keymap.set('n', ']t', function()
                todo_comments.jump_next()
            end, { desc = 'Next todo comment' })

            keymap.set('n', '[t', function()
                todo_comments.jump_prev()
            end, { desc = 'Previous todo comment' })
            todo_comments.setup {
                --       "error" → red
                -- "warning" → yellow
                -- "info" → blue
                -- "hint" → purple
                -- "test" → red
                keywords = {
                    TODO = { icon = '📌', color = 'info' },
                    DONE = { icon = '✅', color = 'hint' },
                    INPROGRESS = { icon = '⏳', color = 'waiting' },
                    FIXME = { icon = '‼️', color = 'error' },
                    PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
                    NOTE = { icon = '📜', color = 'test' },
                    NEXT = { icon = '⏭️', color = 'pink' },
                },
                -- patterns for different filetypes
                highlight = {
                    comments_only = false,
                    multiline = false,
                    multiline_pattern = '^.', -- lua pattern to match the next multiline from the start of the matched keyword
                    multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
                    before = '', -- "fg" or "bg" or empty
                    keyword = 'wide_bg', -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
                    after = 'fg', -- "fg" or "bg" or empty
                    pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
                    max_line_len = 400, -- ignore lines longer than this
                    exclude = {}, -- list of file types to exclude highlighting
                },
                -- colors = {
                --     error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
                --     warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
                --     info = { 'DiagnosticInfo', '#2563EB' },
                --     hint = { 'DiagnosticHint', '#F56D53' },
                --     default = { 'Identifier', '#F56D53' },
                --     test = { 'Identifier', '#90F9A2' },
                -- },
                colors = {
                    error = { '#EE4B2B' }, -- bright red
                    warning = { '#FFB86C' }, -- orange
                    info = { '#99a9c1' }, -- cyan
                    hint = { '#a3b7a6' }, -- green
                    default = { '#BD93F9' }, -- purple
                    test = { '#bab1a0' }, -- chalk
                    waiting = { '#FDDA0D' }, -- chalk
                    pink = { '#F8C8DC' },
                },
                -- add markdown support
                ft_patterns = {
                    markdown = [[TODO:]],
                },
            }
        end,
    },
}
