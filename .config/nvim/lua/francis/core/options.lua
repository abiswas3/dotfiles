vim.cmd 'let g:netrw_liststyle = 3'
vim.g.vimtex_quickfix_mode = 0

local opt = vim.opt

opt.relativenumber = false
opt.number = true
opt.scrolloff = 10

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = 'dark' -- colorschemes that can be light or dark will be made dark
opt.signcolumn = 'yes' -- show sign column so that text doesn't shift

-- backspace
opt.backspace = 'indent,eol,start' -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append 'unnamedplus' -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })

opt.statusline = '%F%m%r%h%w%=%l,%c %p%%'

vim.keymap.set('n', '<leader>ts', function()
    require('typst-preview').start()
end, { desc = 'Start Typst preview' })

vim.keymap.set('n', '<leader>tq', function()
    require('typst-preview').stop()
end, { desc = 'Stop Typst preview' })

vim.keymap.set('n', '<leader>tn', function()
    require('typst-preview').next_page()
end, { desc = 'Next page' })

vim.keymap.set('n', '<leader>tp', function()
    require('typst-preview').prev_page()
end, { desc = 'Previous page' })

vim.keymap.set('n', '<leader>tr', function()
    require('typst-preview').refresh()
end, { desc = 'Refresh preview' })

vim.keymap.set('n', '<leader>tgg', function()
    require('typst-preview').first_page()
end, { desc = 'First page' })

vim.keymap.set('n', '<leader>tG', function()
    require('typst-preview').last_page()
end, { desc = 'Last page' })
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = 'typst',
--     callback = function()
--         -- Keybind to start typst watch in a split
--         vim.keymap.set('n', '<leader>tw', function()
--             vim.cmd 'vsplit'
--             vim.cmd 'vertical resize 20'
--             vim.cmd('terminal typst watch ' .. vim.fn.expand '%')
--             vim.cmd 'wincmd h'
--         end, { buffer = true, desc = 'Start Typst watch' })
--
--         -- Keybind to open PDF in Skim
--         vim.keymap.set('n', '<leader>tr', function()
--             local pdf = vim.fn.expand '%:p:r' .. '.pdf'
--             vim.fn.system('open -a Skim ' .. vim.fn.shellescape(pdf))
--         end, { buffer = true, desc = 'Open PDF in Skim' })
--     end,
-- })
