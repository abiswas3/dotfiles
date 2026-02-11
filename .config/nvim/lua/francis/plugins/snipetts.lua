-- LuaSnip: Snippet engine.
-- Community snippets from friendly-snippets, custom snippets from snippets/ dir.
-- C-s expands, C-k/C-j jump forward/backward through snippet fields.
return {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
        local ls = require 'luasnip'

        -- Load community VS Code-style snippets
        require('luasnip.loaders.from_vscode').lazy_load()

        -- Load custom snippets from ~/.config/nvim/snippets/
        -- To add snippets: edit the JSON files in that directory.
        -- To add a new language: create <lang>.json and register it in package.json.
        require('luasnip.loaders.from_vscode').lazy_load {
            paths = { vim.fn.stdpath 'config' .. '/snippets' },
        }

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
    end,
}
