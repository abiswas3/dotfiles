local contacts = require("francis.custom.contacts")
local calendar = require("francis.custom.calendar")
local timepicker = require("francis.custom.timepicker")
local M = {}

local function save_meeting(meeting)
    local file_path = vim.fn.expand("~/.meetings.toml")
    local f = io.open(file_path, "a")
    if not f then return end
    f:write("\n[[meeting]]\n")
    f:write(string.format('title = "%s"\n', meeting.title))
    f:write(string.format('start_time = "%s"\n', meeting.start_time))
    f:write(string.format('time_zone = "%s"\n', meeting.time_zone))
    f:write("attendees = [\n")
    for i, email in ipairs(meeting.attendees) do
        local comma = i < #meeting.attendees and "," or ""
        f:write(string.format('  "%s"%s\n', email, comma))
    end
    f:write("]\n")
    f:close()
    vim.notify("Meeting saved to " .. file_path)
end

function M.create_meeting()
    local meeting = {}
    vim.ui.input({ prompt = "Meeting Title: " }, function(title)
        if not title or title == "" then return end
        meeting.title = title

        calendar.pick_date(function(date)
            timepicker.pick_time(date, function(time)
                meeting.start_time = date .. " " .. time
                meeting.time_zone = "local"

                contacts.contacts_picker_multi(function(selected)
                    local attendees = {}
                    for _, c in ipairs(selected) do
                        table.insert(attendees, c.value.email)
                    end
                    meeting.attendees = attendees
                    save_meeting(meeting)
                end, false)
            end)
        end)
    end)
end

vim.api.nvim_create_user_command("CreateMeeting", function()
    M.create_meeting()
end, {})

return M
