-- LuaSnip: Snippet engine with custom markdown snippets.
-- Includes blog post frontmatter, meeting notes, and Zola theorem shortcodes
-- (definition, theorem, lemma, remark, corollary).
-- C-s expands, C-k/C-j jump forward/backward through snippet fields.
return {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
        local ls = require 'luasnip'
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node
        local f = ls.function_node

        -- Load community VS Code-style snippets
        require('luasnip.loaders.from_vscode').lazy_load()

        -- Snippet navigation keybinds
        vim.keymap.set('i', '<C-s>', function()
            if ls.expandable() then
                ls.expand()
            end
        end, { desc = 'Expand snippet' })

        vim.keymap.set({ 'i', 's' }, '<C-k>', function()
            if ls.jumpable(1) then
                ls.jump(1)
            end
        end, { desc = 'Jump to next snippet field' })

        vim.keymap.set({ 'i', 's' }, '<C-j>', function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { desc = 'Jump to previous snippet field' })

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

        -- Custom markdown snippets
        ls.add_snippets('markdown', {
            -- Blog post frontmatter (Zola)
            s('post', {
                t '+++',
                t { '', '' },
                t 'title = "param"',
                t { '', '' },
                t 'date = ',
                f(function()
                    return os.date '%Y-%m-%d'
                end),
                t { '', '' },
                t 'updated = ',
                f(function()
                    return os.date '%Y-%m-%d'
                end),
                t { '', '' },
                t 'draft = true',
                t { '', '', '' },
                t '[taxonomies]',
                t { '', '' },
                t 'categories = ["param"]',
                t { '', '' },
                t 'tags = ["one", "two"]',
                t { '', '', '' },
                t '[extra]',
                t { '', '' },
                t 'toc = true',
                t { '', '' },
                t 'math = true',
                t { '', '' },
                t 'hidden = true',
                t { '', '' },
                t '+++',
                t { '', '' },
            }),

            -- Meeting notes template
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

            -- Zola theorem shortcodes
            s('def', {
                t '{% theorem(type="definition") %}',
                t { '', '' },
                i(1),
                t { '', '{% end %}' },
                i(0),
            }),
            s('thm', {
                t '{% theorem(type="theorem") %}',
                t { '', '' },
                i(1),
                t { '', '{% end %}' },
                i(0),
            }),
            s('lemma', {
                t '{% theorem(type="lemma") %}',
                t { '', '' },
                i(1),
                t { '', '{% end %}' },
                i(0),
            }),
            s('remark', {
                t '{% theorem(type="remark") %}',
                t { '', '' },
                i(1),
                t { '', '{% end %}' },
                i(0),
            }),
            s('cor', {
                t '{% theorem(type="corollary") %}',
                t { '', '' },
                i(1),
                t { '', '{% end %}' },
                i(0),
            }),
        })
    end,
}
