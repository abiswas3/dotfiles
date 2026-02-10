-- Todo Comments: Highlights TODO, DONE, INPROGRESS, FIXME, NOTE, NEXT in code/markdown.
-- ]t/[t to jump between todos. Colors are custom-themed.
-- Works outside of code comments too (comments_only = false) for markdown task lists.
return {
    {
        'folke/todo-comments.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local todo_comments = require 'todo-comments'

            vim.keymap.set('n', ']t', function()
                todo_comments.jump_next()
            end, { desc = 'Next todo comment' })

            vim.keymap.set('n', '[t', function()
                todo_comments.jump_prev()
            end, { desc = 'Previous todo comment' })

            todo_comments.setup {
                keywords = {
                    TODO = { icon = '📌', color = 'info' },
                    DONE = { icon = '✅', color = 'hint' },
                    INPROGRESS = { icon = '⏳', color = 'waiting' },
                    FIXME = { icon = '‼️', color = 'error' },
                    PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
                    NOTE = { icon = '📜', color = 'test' },
                    NEXT = { icon = '⏭️', color = 'pink' },
                },
                highlight = {
                    comments_only = false, -- also highlight in non-comment text (markdown)
                    multiline = false,
                    multiline_pattern = '^.',
                    multiline_context = 10,
                    before = '',
                    keyword = 'wide_bg',
                    after = 'fg',
                    pattern = [[.*<(KEYWORDS)\s*:]],
                    max_line_len = 400,
                },
                colors = {
                    error = { '#EE4B2B' },
                    warning = { '#FFB86C' },
                    info = { '#99a9c1' },
                    hint = { '#a3b7a6' },
                    default = { '#BD93F9' },
                    test = { '#bab1a0' },
                    waiting = { '#FDDA0D' },
                    pink = { '#F8C8DC' },
                },
            }
        end,
    },
}
