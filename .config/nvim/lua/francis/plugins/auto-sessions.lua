-- Auto Session: Automatically saves/restores nvim sessions per working directory.
-- <leader>ws saves, <leader>wr restores. Excludes common top-level dirs.
return {
    'rmagatti/auto-session',
    config = function()
        require('auto-session').setup {
            auto_restore_enabled = false,
            auto_session_suppress_dirs = { '~/', '~/Dev/', '~/Downloads', '~/Documents', '~/Desktop/' },
        }

        vim.keymap.set('n', '<leader>wr', '<cmd>SessionRestore<CR>', { desc = 'Restore session for cwd' })
        vim.keymap.set('n', '<leader>ws', '<cmd>SessionSave<CR>', { desc = 'Save session for cwd' })
    end,
}
