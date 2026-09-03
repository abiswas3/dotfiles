vim.g.mapleader = ' '

local keymap = vim.keymap

-- Exit insert mode
keymap.set('i', 'jk', '<ESC>', { desc = 'Exit insert mode with jk' })

-- Clear search highlights
keymap.set('n', '<leader>nh', ':nohl<CR>', { desc = 'Clear search highlights' })

-- Window management
keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split window vertically' })
keymap.set('n', '<leader>sh', '<C-w>s', { desc = 'Split window horizontally' })
keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make splits equal size' })
keymap.set('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close current split' })

-- Tab management
keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', { desc = 'Open new tab' })
keymap.set('n', '<leader>tx', '<cmd>tabclose<CR>', { desc = 'Close current tab' })
keymap.set('n', '<leader>tl', '<cmd>tabn<CR>', { desc = 'Next tab' })
keymap.set('n', '<leader>th', '<cmd>tabp<CR>', { desc = 'Previous tab' })
keymap.set('n', '<leader>tf', '<cmd>tabnew %<CR>', { desc = 'Open current buffer in new tab' })

-- Emacs-style line navigation (Ctrl-a = start, Ctrl-e = end)
local opts = { noremap = true, silent = true }
keymap.set('n', '<C-a>', '^', opts)
keymap.set('n', '<C-e>', '$', opts)
keymap.set('i', '<C-a>', '<C-o>^', opts)
keymap.set('i', '<C-e>', '<C-o>$', opts)

-- Toggle LSP inlay hints
keymap.set('n', '<leader>ci', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { 0 }, { 0 })
end, { desc = 'Toggle LSP inlay hints' })

-- Writing mode: ZenMode + Pencil for distraction-free writing
keymap.set('n', '<leader>pp', function()
    vim.cmd 'ZenMode | Pencil'
end, { desc = 'ZenMode + Pencil ON' })

keymap.set('n', '<leader>pc', function()
    vim.cmd 'close | PencilOff'
end, { desc = 'ZenMode + Pencil OFF' })

-- Git Fugitive bindings
keymap.set('n', '<leader>gd', ':vertical Gdiffsplit!<CR>', { desc = 'Open vertical Git diff split' })
keymap.set('n', '<leader>gh', ':diffget //2<CR>', { desc = 'Diffget from left (OURS)' })
keymap.set('n', '<leader>gl', ':diffget //3<CR>', { desc = 'Diffget from right (THEIRS)' })
keymap.set('n', '<leader>gp', ':diffput //2<CR>', { desc = 'Diffput to left (OURS)' })
keymap.set('n', '<leader>gP', ':diffput //3<CR>', { desc = 'Diffput to right (THEIRS)' })

-- Task management: cycle TODO keywords at end of line
local cycle_keywords = { 'TODO', 'NEXT', 'INPROGRESS', 'DONE' }

local function toggle_todo_right()
    local line = vim.api.nvim_get_current_line()
    local found = false

    for i, kw in ipairs(cycle_keywords) do
        if line:match(kw) then
            local next_kw = cycle_keywords[(i % #cycle_keywords) + 1]
            line = line:gsub(kw .. '[:]?%s*', '')
            line = line .. ' ' .. next_kw .. ':'
            vim.api.nvim_set_current_line(line)
            found = true
            break
        end
    end

    if not found then
        line = line .. ' TODO:'
        vim.api.nvim_set_current_line(line)
    end
end

-- currently disabled
-- keymap.set('n', '<leader>tt', toggle_todo_right, { desc = 'Toggle TODO/INPROGRESS/DONE at end' })

-- Mark a checklist item as DONE with a timestamp
local function mark_task_done_with_timestamp()
    local line = vim.api.nvim_get_current_line()
    local timestamp = os.date '%Y-%m-%d %H:%M'

    if line:match '^%s*%- %[ %]' then
        line = line:gsub('%- %[ %]', '- [x]')

        for _, kw in ipairs { 'TODO', 'NEXT', 'INPROGRESS' } do
            if line:match(kw .. ':') then
                line = line:gsub(kw .. ':', 'DONE:')
                break
            end
        end

        line = line .. ' | DONE: ' .. timestamp
        vim.api.nvim_set_current_line(line)
    end
end

-- keymap.set('n', '<leader>td', mark_task_done_with_timestamp, { desc = 'Mark task DONE with timestamp' })

-- Move all DONE tasks to the bottom of the buffer
local function move_done_to_bottom()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local new_lines = {}
    local done_lines = {}

    for _, line in ipairs(lines) do
        if line:match '^%s*%- %[x%] DONE:' then
            table.insert(done_lines, line)
        else
            table.insert(new_lines, line)
        end
    end

    if #done_lines > 0 then
        table.insert(new_lines, '')
        table.insert(new_lines, '')
        table.insert(new_lines, '')
    end

    for _, line in ipairs(done_lines) do
        table.insert(new_lines, line)
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
end

-- keymap.set('n', '<leader>db', move_done_to_bottom, { desc = 'Move DONE tasks to bottom' })

-- Show and copy full file path to clipboard
keymap.set('n', '<leader>fp', function()
    local full_path = vim.fn.expand '%:p'
    print(full_path)
    vim.fn.setreg('+', full_path)
    vim.notify('Copied: ' .. full_path, vim.log.levels.INFO)
end, { desc = 'Show and copy full file path' })

-- Show and copy full file path with line number to clipboard
keymap.set('n', '<leader>lp', function()
    local full_path = vim.fn.expand '%:p' .. ':' .. vim.fn.line '.'
    print(full_path)
    vim.fn.setreg('+', full_path)
    vim.notify('Copied: ' .. full_path, vim.log.levels.INFO)
end, { desc = 'Show and copy full file path with line number' })

-- Insert a markdown checklist item
-- keymap.set('i', '<C-l>', function()
--     local line = vim.api.nvim_get_current_line()
--     local indent = line:match '^%s*' or ''
--     return indent .. '* [ ] '
-- end, { expr = true, desc = 'Insert checklist item' })

-- Generate a Rust docstring via neogen
keymap.set('n', '<leader>rd', function()
    require('neogen').generate { type = 'func' }
end, { desc = 'Rust docstring (placeholders)' })
