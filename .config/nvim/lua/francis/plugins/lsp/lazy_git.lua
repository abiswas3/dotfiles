-- LazyGit: Full-screen git TUI inside Neovim as a floating window.
-- <leader>lg opens LazyGit for staging, committing, branching, etc.
return {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
        'LazyGit',
        'LazyGitConfig',
        'LazyGitCurrentFile',
        'LazyGitFilter',
        'LazyGitFilterCurrentFile',
    },
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    keys = {
        { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
    config = function()
        vim.api.nvim_set_hl(0, 'LazygitCursor', { fg = '#ffffff', bg = '#000000' })
        vim.api.nvim_set_hl(0, 'LazygitCommitted', { fg = '#00ff00' })

        vim.cmd [[
            augroup LazyGitHighlightFix
                autocmd!
                autocmd FileType lazygit setlocal nocursorline nocursorcolumn
            augroup END
        ]]
    end,
}
