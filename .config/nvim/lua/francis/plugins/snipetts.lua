-- lua/plugins/snippets.lua
return {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
        local ls = require 'luasnip'
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node
        local f = ls.function_node
        -- Load friendly-snippets FIRST
        require('luasnip.loaders.from_vscode').lazy_load()

        -- Then extend markdown to include tex snippets
        ls.filetype_extend('markdown', { 'tex' })
        -- Keybindings
        vim.keymap.set('i', '<C-s>', function()
            if ls.expandable() then
                ls.expand()
            end
        end, { desc = 'Expand snippet' })

        vim.keymap.set({ 'i', 's' }, '<C-k>', function()
            if ls.jumpable(1) then
                ls.jump(1)
            end
        end, { desc = 'Jump to next field' })

        vim.keymap.set({ 'i', 's' }, '<C-j>', function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { desc = 'Jump to previous field' })

        -- Add these AFTER your existing Ctrl-k/Ctrl-j keymaps:
        vim.keymap.set({ 'i', 's' }, '<Tab>', function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            else
                return '<Tab>'
            end
        end, { expr = true, desc = 'Expand or jump snippet' })

        vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { desc = 'Jump to previous snippet field' })

        -- Load auto-generated ones
        local auto_latex = require 'snippets.latex-auto'
        ls.add_snippets('markdown', auto_latex)
        ls.add_snippets('tex', auto_latex)
        -- Custom markdown snippets
        ls.add_snippets('markdown', {
            -- Blog post template
            s('blog', {
                t { '---', '' },
                t 'title: "',
                i(1, 'Title'),
                t { '"', '' },
                t 'authors: "Your Name"',
                t { '', '' },
                t 'date: ',
                f(function()
                    return os.date '%Y-%m-%d'
                end),
                t { '', '' },
                t 'categories: "',
                i(2, 'category'),
                t { '"', '' },
                t 'description: "',
                i(3, 'Description'),
                t { '"', '' },
                t { 'bibliography: ../refs.bib', '' },
                t { '---', '', '' },
                t '# ',
                i(1),
                t { '', '', '' },
                i(0),
            }),

            -- Project template
            s('project', {
                t { '---', '' },
                t 'title: "',
                i(1, 'Project Name'),
                t { '"', '' },
                t 'status: "',
                i(2, 'in-progress'),
                t { '"', '' },
                t 'tags: [',
                i(3, 'tags'),
                t { ']', '' },
                t 'created: ',
                f(function()
                    return os.date '%Y-%m-%d'
                end),
                t { '', '' },
                t { '---', '', '' },
                t '## Overview',
                t { '', '', '' },
                i(0),
            }),

            -- Simple note template
            s('note', {
                t { '---', '' },
                t 'title: "',
                i(1, 'Note Title'),
                t { '"', '' },
                t 'date: ',
                f(function()
                    return os.date '%Y-%m-%d'
                end),
                t { '', '' },
                t 'tags: [',
                i(2),
                t { ']', '' },
                t { '---', '', '', '' },
                i(0),
            }),

            -- Meeting notes
            s('meeting', {
                t { '---', '' },
                t 'title: "',
                i(1, 'Meeting Title'),
                t { '"', '' },
                t 'date: ',
                f(function()
                    return os.date '%Y-%m-%d'
                end),
                t { '', '' },
                t 'attendees: [',
                i(2),
                t { ']', '' },
                t 'tags: [meeting]',
                t { '', '' },
                t { '---', '', '' },
                t '## Agenda',
                t { '', '', '' },
                i(3),
                t { '', '', '' },
                t '## Notes',
                t { '', '', '' },
                i(4),
                t { '', '', '' },
                t '## Action Items',
                t { '', '', '' },
                i(0),
            }),

            -- Callout blocks (blockquote style)
            s('def', {
                t '> [!def] ',
                i(1, 'Title'),
                t { '', '>', '' },
                t '> ',
                i(0),
            }),

            s('thm', {
                t '> [!thm] ',
                i(1, 'Title'),
                t { '', '>', '' },
                t '> ',
                i(0),
            }),

            s('lemma', {
                t '> [!lemma] ',
                i(1, 'Title'),
                t { '', '>', '' },
                t '> ',
                i(0),
            }),

            s('remark', {
                t '> [!remark] ',
                i(1, 'Title'),
                t { '', '>', '' },
                t '> ',
                i(0),
            }),

            s('cor', {
                t '> [!cor] ',
                i(1, 'Title'),
                t { '', '>', '' },
                t '> ',
                i(0),
            }),
        })
    end,
}
