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
