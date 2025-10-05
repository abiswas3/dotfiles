-- ~/.config/nvim/lua/francis/custom/calendar.lua
local vim = vim

local M = {}

-- Returns a table of days and the weekday of the first day
local function get_month_grid(year, month)
    local first_day = os.time({ year = year, month = month, day = 1 })
    local wday = tonumber(os.date("%w", first_day)) -- 0=Sunday
    local days = {}
    local d = 1
    while true do
        local ok, t = pcall(os.time, { year = year, month = month, day = d })
        if not ok then break end
        if tonumber(os.date("%m", t)) ~= month then break end
        table.insert(days, d)
        d = d + 1
    end
    return days, wday
end

-- Floating calendar picker
function M.pick_date(callback)
    local today = os.date("*t")
    local year, month = today.year, today.month
    local days, first_wday = get_month_grid(year, month)

    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = 30,
        height = 10,
        row = 3,
        col = 10,
        style = "minimal",
        border = "rounded",
    })

    local selected = today.day

    local function render()
        local lines = {}
        table.insert(lines, string.format("%04d-%02d", year, month))
        table.insert(lines, "Su Mo Tu We Th Fr Sa")
        local line = string.rep("   ", first_wday)
        for i, d in ipairs(days) do
            if i == selected then
                line = line .. string.format("[%02d]", d)
            else
                line = line .. string.format("%02d ", d)
            end
            if (first_wday + i) % 7 == 0 then
                table.insert(lines, line)
                line = ""
            end
        end
        if line ~= "" then table.insert(lines, line) end
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    end

    render()

    local function update(delta)
        selected = math.min(math.max(1, selected + delta), #days)
        render()
    end

    local keymap_opts = { noremap = true, nowait = true, silent = true }

    vim.api.nvim_buf_set_keymap(buf, "n", "<Left>", "", { callback = function() update(-1) end, unpack(keymap_opts) })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Right>", "", { callback = function() update(1) end, unpack(keymap_opts) })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Up>", "", { callback = function() update(-7) end, unpack(keymap_opts) })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Down>", "", { callback = function() update(7) end, unpack(keymap_opts) })
    vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "", { callback = function()
        vim.api.nvim_win_close(win, true)
        callback(string.format("%04d-%02d-%02d", year, month, days[selected]))
    end, unpack(keymap_opts) })
end

return M
