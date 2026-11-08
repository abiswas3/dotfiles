-- bibpicker: search the master library.bib and copy entries into the current project's own .bib.
--
-- <leader>fb opens a Telescope picker over the library. In the picker:
--   <CR>   copy the entry into the project's .bib (unless its key is already there) and insert the key at the cursor
--   <C-y>  only copy the entry
--   <Tab>  mark several entries first; <CR> then handles all of them
-- The library is never modified. Its path is $BIB_LIBRARY, or vim.g.bib_library, or ~/Papers/library.bib.
-- The project's .bib is found from \addbibresource{...} / \bibliography{...} in the main .tex file (VimTeX knows
-- which one that is), with references.bib in the project root as a fallback. If you are editing a .bib file
-- itself, entries go into that file.
local M = {}

function M.library_path()
    return vim.env.BIB_LIBRARY or vim.g.bib_library or vim.fn.expand '~/Papers/library.bib'
end

-- ---------------------------------------------------------------- reading .bib files

-- The value of `name = ...` inside the text of one entry (in braces, in quotes or a bare word), or ''.
local function field(text, name)
    local src = '\n' .. text
    local _, e = src:lower():find('[\n,]%s*' .. name .. '%s*=%s*')
    if not e then
        return ''
    end
    local c = src:sub(e + 1, e + 1)
    local value
    if c == '{' then
        local depth, i = 0, e + 1
        while i <= #src do
            local ch = src:sub(i, i)
            if ch == '{' then
                depth = depth + 1
            elseif ch == '}' then
                depth = depth - 1
                if depth == 0 then
                    break
                end
            end
            i = i + 1
        end
        value = src:sub(e + 2, i - 1)
    elseif c == '"' then
        local i = e + 2
        while i <= #src and not (src:sub(i, i) == '"' and src:sub(i - 1, i - 1) ~= '\\') do
            i = i + 1
        end
        value = src:sub(e + 2, i - 1)
    else
        value = src:match('^[^,\n]*', e + 1)
    end
    value = value:gsub('[{}]', ''):gsub('%s+', ' ')
    return vim.trim(value)
end

-- "Cormode", "Cormode & Kanza" or "Cormode et al." from a BibTeX author list.
local function short_authors(authors)
    if authors == '' then
        return ''
    end
    local function last(name)
        name = vim.trim(name)
        if name:find ',' then
            return vim.trim(name:match '^[^,]*')
        end
        return name:match '%S+$' or name
    end
    local names = vim.split(authors, ' and ', { plain = true })
    if #names == 1 then
        return last(names[1])
    elseif #names == 2 then
        return last(names[1]) .. ' & ' .. last(names[2])
    end
    return last(names[1]) .. ' et al.'
end

-- Entries of a .bib file (a list of lines): { key, type, text (verbatim), display, ordinal }.
-- @comment, @string and @preamble are skipped.
function M.parse(lines)
    local entries, cur = {}, nil

    local function finish()
        if not cur then
            return
        end
        while #cur.lines > 0 and (vim.trim(cur.lines[#cur.lines]) == '' or cur.lines[#cur.lines]:match '^%s*%%') do
            table.remove(cur.lines)
        end
        if cur.key then
            local text = table.concat(cur.lines, '\n')
            local authors = field(text, 'author')
            if authors == '' then
                authors = field(text, 'editor')
            end
            local year = field(text, 'year')
            if year == '' then
                year = field(text, 'date'):match '%d%d%d%d' or ''
            end
            local title = field(text, 'title')
            local venue = field(text, 'journal')
            if venue == '' then
                venue = field(text, 'booktitle')
            end
            table.insert(entries, {
                key = cur.key,
                type = cur.type,
                text = text,
                display = string.format('%-24s %4s  %s  [%s]', short_authors(authors), year, title, cur.key),
                ordinal = table.concat({ cur.key, authors, year, title, venue }, ' '),
            })
        end
        cur = nil
    end

    for _, line in ipairs(lines) do
        local kind, rest = line:match '^%s*@(%w+)%s*[{(](.*)$'
        if kind then
            finish()
            kind = kind:lower()
            if kind == 'comment' or kind == 'string' or kind == 'preamble' then
                cur = { lines = { line } } -- collected so that its lines do not end up in the previous entry
            else
                cur = { lines = { line }, type = kind, key = rest:match '^%s*([^,%s]+)%s*,' }
            end
        elseif cur then
            table.insert(cur.lines, line)
        end
    end
    finish()
    return entries
end

-- ---------------------------------------------------------------- the project's own .bib

-- Project root and main .tex file of the current buffer.
local function project()
    local vt = vim.b.vimtex
    if vt and vt.root and vt.tex then
        return vt.root, vt.tex
    end
    local root = vim.fn.getcwd()
    for _, name in ipairs { 'main.tex', 'thesis.tex', 'paper.tex' } do
        if vim.fn.filereadable(root .. '/' .. name) == 1 then
            return root, root .. '/' .. name
        end
    end
    return root, nil
end

-- The .bib files named in the main .tex file, else references.bib in the root. Existing files only (if any exist).
function M.project_bibs(root, main)
    local found = {}
    local function add(path)
        path = vim.trim(path)
        if not path:find '%.%w+$' then
            path = path .. '.bib' -- \bibliography{refs} means refs.bib
        end
        if path:sub(1, 1) ~= '/' then
            path = root .. '/' .. path
        end
        if path ~= M.library_path() and not vim.tbl_contains(found, path) then
            table.insert(found, path)
        end
    end
    if main and vim.fn.filereadable(main) == 1 then
        for _, line in ipairs(vim.fn.readfile(main)) do
            line = line:gsub('%%.*$', '') -- ignore comments
            for path in line:gmatch '\\addbibresource[^{]*{([^}]*)}' do
                add(path)
            end
            for list in line:gmatch '\\bibliography{([^}]*)}' do
                for path in list:gmatch '[^,]+' do
                    add(path)
                end
            end
        end
    end
    if #found == 0 and vim.fn.filereadable(root .. '/references.bib') == 1 then
        add 'references.bib'
    end
    local existing = vim.tbl_filter(function(p)
        return vim.fn.filereadable(p) == 1
    end, found)
    return #existing > 0 and existing or found
end

-- Copy `entry` (verbatim) to the end of the .bib file `path`.
-- Returns 'added', 'present' (same key already there), 'case' (the key is there with different capitals: biber
-- treats those as different keys, BibTeX does not) or 'unsaved' (the file is open with unsaved changes),
-- and the key as it is spelled in that file.
function M.add_entry(entry, path)
    local lines = vim.fn.filereadable(path) == 1 and vim.fn.readfile(path) or {}
    for _, e in ipairs(M.parse(lines)) do
        if e.key:lower() == entry.key:lower() then
            return e.key == entry.key and 'present' or 'case', e.key
        end
    end
    local buf = vim.fn.bufnr(vim.fn.fnamemodify(path, ':p'))
    if buf ~= -1 and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
        return 'unsaved', entry.key
    end
    if #lines > 0 and vim.trim(lines[#lines]) ~= '' then
        table.insert(lines, '')
    end
    vim.list_extend(lines, vim.split(entry.text, '\n', { plain = true }))
    vim.fn.writefile(lines, path)
    if buf ~= -1 and vim.api.nvim_buf_is_loaded(buf) then
        vim.cmd 'checktime' -- pick up the change in the open buffer
    end
    return 'added', entry.key
end

-- Add the entries to `path`; with `insert_keys` also put their keys at the cursor, comma separated.
local function add_entries(picked, path, insert_keys)
    local counts = { added = 0, present = 0 }
    local keys = {}
    for _, entry in ipairs(picked) do
        local status, key = M.add_entry(entry, path)
        if status == 'added' then
            counts.added = counts.added + 1
        elseif status == 'present' then
            counts.present = counts.present + 1
        elseif status == 'case' then
            counts.present = counts.present + 1
            vim.notify(entry.key .. ' is in ' .. vim.fn.fnamemodify(path, ':t') .. ' with other capitals; biber treats those as different keys', vim.log.levels.WARN)
        else
            vim.notify(vim.fn.fnamemodify(path, ':t') .. ' has unsaved changes: save it and try again', vim.log.levels.ERROR)
            return
        end
        table.insert(keys, key)
    end
    if insert_keys then
        vim.api.nvim_put({ table.concat(keys, ',') }, 'c', false, true)
    end
    vim.notify(string.format('%d added to %s, %d already there', counts.added, vim.fn.fnamemodify(path, ':~:.'), counts.present))
end

-- ---------------------------------------------------------------- the picker

function M.open()
    local library = M.library_path()
    if vim.fn.filereadable(library) == 0 then
        vim.notify('bibpicker: no library at ' .. library, vim.log.levels.ERROR)
        return
    end
    local entries = M.parse(vim.fn.readfile(library))

    -- work out the target .bib now, while the cursor is still in the buffer being edited
    local filetype = vim.bo.filetype
    local bibs
    if filetype == 'bib' or filetype == 'bibtex' then
        bibs = { vim.fn.expand '%:p' }
    else
        bibs = M.project_bibs(project())
    end

    local pickers = require 'telescope.pickers'
    local finders = require 'telescope.finders'
    local conf = require('telescope.config').values
    local previewers = require 'telescope.previewers'
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'

    pickers
        .new({}, {
            prompt_title = 'library.bib (' .. #entries .. ' entries)',
            finder = finders.new_table {
                results = entries,
                entry_maker = function(e)
                    return { value = e, display = e.display, ordinal = e.ordinal }
                end,
            },
            sorter = conf.generic_sorter {},
            previewer = previewers.new_buffer_previewer {
                title = 'Entry',
                define_preview = function(self, entry)
                    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(entry.value.text, '\n', { plain = true }))
                    vim.bo[self.state.bufnr].filetype = 'bib'
                end,
            },
            attach_mappings = function(prompt_bufnr, map)
                local function choose(insert_keys)
                    local picked = {}
                    for _, s in ipairs(action_state.get_current_picker(prompt_bufnr):get_multi_selection()) do
                        table.insert(picked, s.value)
                    end
                    if #picked == 0 then
                        local s = action_state.get_selected_entry()
                        if not s then
                            return
                        end
                        picked = { s.value }
                    end
                    actions.close(prompt_bufnr)
                    insert_keys = insert_keys and filetype ~= 'bib' and filetype ~= 'bibtex'
                    vim.schedule(function()
                        if #bibs == 0 then
                            vim.notify('bibpicker: found no .bib file for this project (\\addbibresource, \\bibliography or references.bib)', vim.log.levels.ERROR)
                        elseif #bibs == 1 then
                            add_entries(picked, bibs[1], insert_keys)
                        else
                            vim.ui.select(bibs, {
                                prompt = 'Add to which .bib?',
                                format_item = function(p)
                                    return vim.fn.fnamemodify(p, ':~:.')
                                end,
                            }, function(choice)
                                if choice then
                                    add_entries(picked, choice, insert_keys)
                                end
                            end)
                        end
                    end)
                end
                actions.select_default:replace(function()
                    choose(true)
                end)
                map({ 'i', 'n' }, '<C-y>', function()
                    choose(false)
                end)
                return true
            end,
        })
        :find()
end

return M
