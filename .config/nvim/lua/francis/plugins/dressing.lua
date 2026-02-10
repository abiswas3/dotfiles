-- Dressing: Improves vim.ui.select() and vim.ui.input() with floating windows.
-- Makes rename prompts, code action menus, etc. look much nicer.
-- Calendar: Provides a calendar view (used by custom meeting module).
return {
    {
        'stevearc/dressing.nvim',
        event = 'VeryLazy',
    },
    {
        'itchyny/calendar.vim',
        config = function()
            vim.g.calendar_view = 'month'
        end,
    },
}
