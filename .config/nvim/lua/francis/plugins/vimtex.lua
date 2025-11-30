-- VimTeX: The core LaTeX plugin for Neovim
-- Provides compilation, navigation, text objects, and more
return {
    'lervag/vimtex',
    -- Only load when opening LaTeX files for faster startup
    ft = { 'tex', 'bib' },

    config = function()
        -- Set the default compiler to latexmk (handles multiple passes automatically)
        vim.g.vimtex_compiler_method = 'latexmk'

        -- PDF viewer configuration for macOS
        -- Skim supports forward search (jump from code to PDF) and backward search
        vim.g.vimtex_view_method = 'skim'
        vim.g.vimtex_compiler_progname = 'nvr'

        -- Enable forward search: jump to PDF location from Neovim
        vim.g.vimtex_view_skim_sync = 1
        vim.g.vimtex_view_skim_activate = 1

        -- Compiler options for latexmk
        vim.g.vimtex_compiler_latexmk = {
            -- Build in continuous mode (watches for file changes)
            continuous = 1,
            -- Output directory for auxiliary files (keeps project clean)
            out_dir = 'build',
            -- Additional options: -pdf ensures PDF output, -interaction=nonstopmode prevents hanging
            options = {
                '-pdf',
                '-interaction=nonstopmode',
                '-synctex=1', -- Required for forward/backward search
            },
        }

        -- Disable overfull/underfull box warnings (they're often not critical)
        vim.g.vimtex_quickfix_ignore_filters = {
            'Underfull',
            'Overfull',
        }

        -- Folding configuration (optional, disable if you don't like auto-folding)
        vim.g.vimtex_fold_enabled = 0

        -- Concealment configuration (hides LaTeX syntax for cleaner reading)
        -- Set to 0 to disable, 1 to enable in normal mode, 2 for insert mode too
        vim.g.vimtex_syntax_conceal_disable = 0
    end,
}
