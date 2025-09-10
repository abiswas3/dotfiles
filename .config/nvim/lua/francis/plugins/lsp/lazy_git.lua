
return {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    },
    config = function()
        -- Override lazygit floating window highlight groups
        vim.api.nvim_set_hl(0, "LazygitCursor", { fg = "#ffffff", bg = "#000000" })
        vim.api.nvim_set_hl(0, "LazygitCommitted", { fg = "#00ff00" })

        -- Disable cursorline and cursorcolumn in lazygit floating window
        vim.cmd([[
          augroup LazyGitHighlightFix
            autocmd!
            autocmd FileType lazygit setlocal nocursorline nocursorcolumn
          augroup END
        ]])
    end,

}
