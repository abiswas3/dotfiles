-- ~/.config/nvim/lua/francis/custom/timepicker.lua
local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local vim = vim

local M = {}

-- Ensure luatz is loaded
local ok, luatz = pcall(require, "luatz")
if not ok then
    vim.notify("Please install luatz: https://github.com/daurnimator/luatz", vim.log.levels.ERROR)
    return M
end

local zones = require("luatz.zones")

-- Map city names to IANA timezones
local time_zones = {
    ["Auckland, NZ"]      = "Pacific/Auckland",
    ["ChristChurch, NZ"]  = "Pacific/Chatham",
    ["Sydney, AU"]        = "Australia/Sydney",
    ["Kolkata, India"]    = "Asia/Kolkata",
    ["Madrid, Spain"]     = "Europe/Madrid",
    ["NY, USA"]           = "America/New_York",
    ["Chicago, USA"]      = "America/Chicago",
    ["Denver, USA"]       = "America/Denver",
    ["Seattle, USA"]      = "America/Los_Angeles",
}

-- Convert given date/time in local to a specific timezone
local function tz_convert(y, mo, d, h, m, tz_name)
    local utc_time = os.time({ year=y, month=mo, day=d, hour=h, min=m })
    local dt = luatz.date.from_epoch(utc_time, "UTC")
    local zone = zones[tz_name]
    if not zone then
        vim.notify("Unknown timezone: " .. tz_name, vim.log.levels.WARN)
        return h, m
    end
    local local_dt = dt:to_zone(zone)
    return local_dt.hour, local_dt.min
end

function M.pick_time(date, callback)
    local y, mo, d = date:match("(%d+)-(%d+)-(%d+)")
    y, mo, d = tonumber(y), tonumber(mo), tonumber(d)

    local popup = Popup({
        enter = true,
        focusable = true,
        border = { style = "rounded" },
        position = "50%",
        size = { width = 50, height = #time_zones + 4 },
    })

    popup:mount()
    popup:on(event.BufLeave, function()
        popup:unmount()
    end)

    local current_input = "09:00"

    local function update_preview(h, m)
        local lines = { "Time zone preview for " .. string.format("%02d:%02d", h, m) }
        for city, tz in pairs(time_zones) do
            local hh, mm = tz_convert(y, mo, d, h, m, tz)
            table.insert(lines, string.format("%s: %02d:%02d", city, hh, mm))
        end
        vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)
    end

    local function loop()
        vim.ui.input({ prompt = "Enter time (HH:MM 24h): ", default = current_input }, function(input)
            if not input then
                popup:unmount()
                return
            end

            local h, m = input:match("(%d+):(%d+)")
            h, m = tonumber(h), tonumber(m)
            if not h or not m or h > 23 or m > 59 then
                vim.notify("Invalid time format. Use HH:MM 24h", vim.log.levels.ERROR)
                current_input = input
                return loop()
            end

            current_input = string.format("%02d:%02d", h, m)
            update_preview(h, m)

            vim.ui.input({ prompt = "Press Enter to confirm or type new time: ", default = current_input }, function(conf)
                if conf == "" or conf == nil or conf == current_input then
                    popup:unmount()
                    callback(current_input)
                else
                    current_input = conf
                    loop()
                end
            end)
        end)
    end

    -- Initial preview
    local ih, im = current_input:match("(%d+):(%d+)")
    update_preview(tonumber(ih), tonumber(im))
    loop()
end

return M
