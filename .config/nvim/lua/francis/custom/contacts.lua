-- ~/.config/nvim/lua/francis/custom/contacts.lua
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

-- parse ~/.contacts.toml
local function parse_contacts()
    local contact_file = vim.fn.expand("~/.contacts.toml")
    local contacts = {}
    local current = nil

    local file = io.open(contact_file, "r")
    if not file then
        vim.notify("Could not read contacts file: " .. contact_file, vim.log.levels.ERROR)
        return contacts
    end

    for line in file:lines() do
        line = line:match("^%s*(.-)%s*$")
        if line:match("^%[%[contacts%]%]") then
            current = {}
            table.insert(contacts, current)
        elseif current and line ~= "" then
            local k, v = line:match("^(%w+)%s*=%s*\"(.-)\"")
            if k and v then
                current[k] = v
            end
        end
    end

    file:close()
    return contacts
end

-- Multi-select contacts picker
-- callback(selected) returns list of contacts
-- insert_emails_in_buffer = true → inserts into buffer (for :Contacts)
function M.contacts_picker_multi(callback, insert_emails_in_buffer)
    local contacts_list = parse_contacts()
    local entries = {}

    for _, c in ipairs(contacts_list) do
        local display = string.format("%s (%s)", c.name or "", c.email or "")
        table.insert(entries, { display = display, value = c })
    end

    pickers.new({}, {
        prompt_title = "Select Attendees (Tab to mark, Enter to confirm)",
        finder = finders.new_table {
            results = entries,
            entry_maker = function(entry)
                return {
                    value = entry.value,
                    display = entry.display,
                    ordinal = entry.display,
                }
            end,
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            map("i", "<Tab>", actions.toggle_selection)
            map("n", "<Tab>", actions.toggle_selection)

            map("i", "<CR>", function()
                local picker = action_state.get_current_picker(prompt_bufnr)
                local selection = picker:get_multi_selection()
                actions.close(prompt_bufnr)

                if #selection == 0 then
                    vim.notify("No contacts selected", vim.log.levels.WARN)
                    return
                end

                -- insert emails in buffer only if requested
                if insert_emails_in_buffer then
                    local lines = {}
                    for _, entry in ipairs(selection) do
                        if entry.value.email and entry.value.email ~= "" then
                            table.insert(lines, entry.value.email)
                        end
                    end
                    vim.api.nvim_put(lines, "c", true, true)
                end

                if callback then
                    callback(selection)
                end
            end)

            return true
        end,
    }):find()
end

-- Single-select wrapper
function M.contacts_picker()
    M.contacts_picker_multi(nil, true)
end

return M
