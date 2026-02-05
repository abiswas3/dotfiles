vim.g.mapleader = ' '

local keymap = vim.keymap -- for conciseness

keymap.set('i', 'jk', '<ESC>', { desc = 'Exit insert mode with jk' })

keymap.set('n', '<leader>nh', ':nohl<CR>', { desc = 'Clear search highlights' })

-- increment/decrement numbers
-- keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
-- keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split window vertically' }) -- split window vertically
keymap.set('n', '<leader>sh', '<C-w>s', { desc = 'Split window horizontally' }) -- split window horizontally
keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make splits equal size' }) -- make split windows equal width & height
keymap.set('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close current split' }) -- close current split window

keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', { desc = 'Open new tab' }) -- open new tab
keymap.set('n', '<leader>tx', '<cmd>tabclose<CR>', { desc = 'Close current tab' }) -- close current tab
keymap.set('n', '<leader>tn', '<cmd>tabn<CR>', { desc = 'Go to next tab' }) --  go to next tab
keymap.set('n', '<leader>tp', '<cmd>tabp<CR>', { desc = 'Go to previous tab' }) --  go to previous tab
keymap.set('n', '<leader>tf', '<cmd>tabnew %<CR>', { desc = 'Open current buffer in new tab' }) --  move current buffer to new tab

-- Standard navigation shortcuts
local opts = { noremap = true, silent = true }
-- Remap Ctrl-a to beginning of line (^) and Ctrl-e to end of line ($)
keymap.set('n', '<C-a>', '^', opts)
keymap.set('n', '<C-e>', '$', opts)
keymap.set('i', '<C-a>', '<C-o>^', opts)
keymap.set('i', '<C-e>', '<C-o>$', opts)

-- Toggle LSP inlay hints
keymap.set('n', '<leader>ci', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { 0 }, { 0 })
end, { desc = 'Toggle LSP inlay hints' })

-- Writing
-- Enter ZenMode + Pencil
keymap.set('n', '<leader>pp', function()
    vim.cmd 'ZenMode | Pencil'
end, { desc = 'ZenMode + Pencil ON' })

-- Exit ZenMode + Pencil
keymap.set('n', '<leader>pc', function()
    vim.cmd 'close | PencilOff'
end, { desc = 'ZenMode + Pencil OFF' })

-- Git Fugitive bindings
-- Open vertical Git diff split
keymap.set('n', '<leader>gd', ':vertical Gdiffsplit!<CR>', { desc = 'Open vertical Git diff split' })
-- Diffget from left buffer (OURS)
keymap.set('n', '<leader>gh', ':diffget //2<CR>', { desc = 'Diffget from left (OURS)' })
-- Diffget from right buffer (THEIRS)
keymap.set('n', '<leader>gl', ':diffget //3<CR>', { desc = 'Diffget from right (THEIRS)' })
-- Diffput to left buffer (OURS)
keymap.set('n', '<leader>gp', ':diffput //2<CR>', { desc = 'Diffput to left (OURS)' })
-- Diffput to right buffer (THEIRS)
keymap.set('n', '<leader>gP', ':diffput //3<CR>', { desc = 'Diffput to right (THEIRS)' })

-- TODO: Make code navigation easier, I want to use [, ] for forward and backward
local bufnr = vim.api.nvim_get_current_buf()
keymap.set('n', '<leader>xh', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr })
end, { desc = 'Toggle hints' })
-- vim.api.nvim_create_user_command('Contacts', function()
--     require('francis.custom.contacts').contacts_picker()
-- end, {})
--
-- -- In lua/francis/core/keymaps.lua or maps.lua
-- vim.keymap.set('n', '<leader>m', function()
--     require('francis.custom.meeting').create_meeting()
-- end, { desc = 'Create a new meeting' })

local cycle_keywords = { 'TODO', 'NEXT', 'INPROGRESS', 'DONE' }

local function toggle_todo_right()
    local line = vim.api.nvim_get_current_line()
    local found = false

    -- Remove existing keyword from anywhere in the line
    for i, kw in ipairs(cycle_keywords) do
        if line:match(kw) then
            -- determine next keyword in cycle
            local next_kw = cycle_keywords[(i % #cycle_keywords) + 1]
            -- remove the old keyword
            line = line:gsub(kw .. '[:]?%s*', '')
            -- append new keyword at the end
            line = line .. ' ' .. next_kw .. ':'
            vim.api.nvim_set_current_line(line)
            found = true
            break
        end
    end

    -- If no keyword found, append TODO: by default
    if not found then
        line = line .. ' TODO:'
        vim.api.nvim_set_current_line(line)
    end
end
-- Keymap: <leader>tt
vim.keymap.set('n', '<leader>tt', toggle_todo_right, { desc = 'Toggle TODO/INPROGRESS/DONE at end' })

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

        -- append done timestamp
        line = line .. ' | DONE: ' .. timestamp
        vim.api.nvim_set_current_line(line)
    end
end

vim.keymap.set('n', '<leader>td', mark_task_done_with_timestamp, { desc = 'Mark task DONE with timestamp' })
--
-- local function mark_task_done()
--     local line = vim.api.nvim_get_current_line()
--     local timestamp = os.date '%Y-%m-%d %H:%M'
--
--     -- Match a checkbox line
--     if line:match '^%s*%- %[ %]' then
--         -- replace [ ] with [x]
--         line = line:gsub('%- %[ %]', '- [x]')
--
--         -- if it has TODO: (or NEXT/INPROGRESS), replace with DONE:
--         for _, kw in ipairs { 'TODO', 'NEXT', 'INPROGRESS' } do
--             if line:match(kw .. ':') then
--                 line = line:gsub(kw .. ':', 'DONE: ' .. timestamp .. ':')
--                 break
--             end
--         end
--     elseif line:match '^%s*%- %[x%] DONE:' then
--         -- already marked DONE — do nothing (no toggle back)
--         vim.notify('Task already DONE', vim.log.levels.INFO)
--         return
--     else
--         vim.notify('Not a task line (- [ ] ...)', vim.log.levels.WARN)
--         return
--     end
--
--     vim.api.nvim_set_current_line(line)
-- end
--
-- -- Keymap: <leader>td = mark as done
-- vim.keymap.set('n', '<leader>td', mark_task_done, { desc = 'Mark task DONE with timestamp' })
--
local function move_done_to_bottom()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local new_lines = {}
    local done_lines = {}

    for _, line in ipairs(lines) do
        if line:match '^%s*%- %[x%] DONE:' then
            table.insert(done_lines, line) -- collect DONE lines
        else
            table.insert(new_lines, line) -- keep other lines in place
        end
    end

    -- add 3 empty lines before DONEs
    if #done_lines > 0 then
        table.insert(new_lines, '') -- line 1
        table.insert(new_lines, '') -- line 2
        table.insert(new_lines, '') -- line 3
    end
    -- append DONE lines at the end
    for _, line in ipairs(done_lines) do
        table.insert(new_lines, line)
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
end

-- Keymap: <leader>db to move all DONEs to bottom
vim.keymap.set('n', '<leader>db', move_done_to_bottom, { desc = 'Move DONE tasks to bottom' })

local function parse_due(line)
    -- look for "| due: YYYY-MM-DD"
    local due = line:match '|%s*due:%s*(%d%d%d%d%-%d%d%-%d%d)'
    if due then
        return due
    else
        return nil
    end
end

vim.keymap.set('n', '<leader>cp', function()
    local input_file = vim.fn.expand '%:p'
    -- local output_dir = vim.fn.expand '%:p:h'
    local output_dir = vim.env.HOME .. '/GraphsAndPolynomials/publish'
    local output_file = output_dir .. '/' .. vim.fn.expand '%:t:r' .. '.html'

    local cmd = string.format(
        [[pandoc "%s/GraphsAndPolynomials/templates/shared-macros.tex" "%s" \
        --to html5 \
        --lua-filter="%s/GraphsAndPolynomials/custom_code_block.lua" \
        --citeproc \
        --mathjax \
        --template "%s/GraphsAndPolynomials/templates/blog.html" \
        --csl="%s/GraphsAndPolynomials/templates/harvard.csl" \
        --metadata link-citations=true \
        --bibliography="%s/GraphsAndPolynomials/refs.bib" \
        --strip-comments \
        --from markdown+smart \
        --section-divs \
        --toc \
        --toc-depth=3 \
        --metadata build_date="%s" \
        --output "%s"]],
        vim.env.HOME,
        input_file,
        vim.env.HOME,
        vim.env.HOME,
        vim.env.HOME,
        vim.env.HOME,
        os.date '%Y-%m-%d %H:%M:%S %z',
        output_file
    )

    vim.fn.jobstart(cmd, {
        on_exit = function(_, exit_code)
            if exit_code == 0 then
                vim.notify('Compiled: ' .. output_file, vim.log.levels.INFO)
            else
                vim.notify('Pandoc compilation failed', vim.log.levels.ERROR)
            end
        end,
        on_stderr = function(_, data)
            if data and #data > 0 then
                vim.notify(table.concat(data, '\n'), vim.log.levels.ERROR)
            end
        end,
    })
end, { desc = 'Compile to HTML with Pandoc' })

vim.keymap.set('n', '<leader>cP', function()
    local input_file = vim.fn.expand '%:p'
    local output_dir = vim.fn.expand '%:p:h'
    local output_file = output_dir .. '/' .. vim.fn.expand '%:t:r' .. '.html'

    local cmd = string.format(
        [[pandoc "%s/GraphsAndPolynomials/templates/shared-macros.tex" "%s" \
        --to html5 \
        --lua-filter="%s/GraphsAndPolynomials/custom_code_block.lua" \
        --citeproc \
        --mathjax \
        --template "%s/GraphsAndPolynomials/templates/blog.html" \
        --csl="%s/GraphsAndPolynomials/templates/harvard.csl" \
        --metadata link-citations=true \
        --bibliography="%s/GraphsAndPolynomials/refs.bib" \
        --strip-comments \
        --from markdown+smart \
        --section-divs \
        --toc \
        --toc-depth=3 \
        --metadata build_date="%s" \
        --output "%s"]],
        vim.env.HOME,
        input_file,
        vim.env.HOME,
        vim.env.HOME,
        vim.env.HOME,
        vim.env.HOME,
        os.date '%Y-%m-%d %H:%M:%S %z',
        output_file
    )

    vim.fn.jobstart(cmd, {
        on_exit = function(_, exit_code)
            if exit_code == 0 then
                vim.fn.jobstart('open ' .. vim.fn.shellescape(output_file))
                vim.notify('Compiled and opened in browser', vim.log.levels.INFO)
            else
                vim.notify('Pandoc compilation failed', vim.log.levels.ERROR)
            end
        end,
    })
end, { desc = 'Compile and preview in browser' })

-- Keymap to display full file path
-- this shows full path and copies it clipboard
vim.keymap.set('n', '<leader>fp', function()
    local full_path = vim.fn.expand '%:p'
    print(full_path)
    vim.fn.setreg('+', full_path) -- Also copy to clipboard
    vim.notify('Copied: ' .. full_path, vim.log.levels.INFO)
end, { desc = 'Show and copy full file path' })

vim.keymap.set('i', '<C-l>', function()
    local line = vim.api.nvim_get_current_line()
    local indent = line:match '^%s*' or ''
    return indent .. '* [ ] '
end, { expr = true, desc = 'Insert checklist item' })

vim.keymap.set('n', '<C-l>', function()
    local line = vim.api.nvim_get_current_line()
    local indent = line:match '^%s*' or ''
    vim.api.nvim_put({ indent .. '* [ ] ' }, 'l', true, true)
    vim.cmd 'startinsert!'
end, { desc = 'Insert checklist item' })

-- This did not work perfectly fix, later.
-- vim.keymap.set('v', '<leader>rc', ':s/^/> /<CR>gv:s/\\%V> /> [!note] /<CR>:noh<CR>',
--   { desc = "Obsidian styled callout", silent = true })

vim.keymap.set('v', '<leader>tb', function()
    -- Save register and selection
    local saved_reg = vim.fn.getreg '"'
    vim.cmd 'normal! "xy'

    local text = vim.fn.getreg 'x'

    local wrapped = table.concat({
        '{% theorem(type="box") %}',
        '',
        text,
        '',
        '{% end %}',
    }, '\n')

    vim.fn.setreg('x', wrapped)
    vim.cmd 'normal! gv"xp'

    vim.fn.setreg('"', saved_reg)
end, { desc = 'Wrap selection in theorem box' })

vim.keymap.set('n', '<leader>rd', function()
    require('neogen').generate { type = 'func' }
end, { desc = 'Rust docstring (placeholders)' })
