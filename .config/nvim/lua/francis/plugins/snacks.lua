-- Utility dependencies used by custom modules (meeting, calendar, contacts).
-- nui.nvim: UI component library for floating windows and popups.
-- luatz: Timezone conversion library (used by custom timepicker).
-- luarocks.nvim: Lua package manager bridge for native Lua deps.
return {
    {
        'MunifTanjim/nui.nvim',
        lazy = true,
    },
    {
        'daurnimator/luatz',
        lazy = false,
    },
    {
        'vhyrro/luarocks.nvim',
        priority = 1000,
        config = true,
    },
}
