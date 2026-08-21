vim.cmd 'let g:netrw_liststyle = 3'
vim.g.vimtex_quickfix_mode = 0

local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.scrolloff = 10

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

-- true color support (required for most colorschemes)
opt.termguicolors = true
opt.background = 'dark'
opt.signcolumn = 'yes'

-- backspace
opt.backspace = 'indent,eol,start'

-- clipboard
opt.clipboard:append 'unnamedplus'

-- split windows
opt.splitright = true
opt.splitbelow = true

-- turn off swapfile
opt.swapfile = false

-- transparent background
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })

-- show full file path in statusline
opt.statusline = '%F%m%r%h%w%=%l,%c %p%%'

-- Spell is window-local, not buffer-local: once it is on in a window it stays
-- on across `:e` to a different file. Default OFF globally, then drive it on
-- per filetype. Fires on both FileType and BufWinEnter to catch cases where
-- the buffer is reused in a window that already had spell enabled.
vim.opt.spell = false
vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter' }, {
    callback = function()
        local ft = vim.bo.filetype
        local spell_filetypes = {
            markdown = true,
            typst = true,
            tex = true,
            plaintex = true,
            text = true,
        }
        if spell_filetypes[ft] then
            vim.wo.spell = true
            vim.opt_local.spelllang = 'en_gb'
        else
            vim.wo.spell = false
        end
    end,
})
