-- VimTeX: Full LaTeX editing support.
-- Compilation via latexmk (continuous mode), PDF viewing in Skim with forward/backward search.
-- Skim synctex support lets you jump between source and PDF.
return {
    'lervag/vimtex',
    ft = { 'tex', 'bib' },
    config = function()
        vim.g.vimtex_compiler_method = 'latexmk'

        -- PDF viewer: Skim on macOS (supports synctex forward/backward search)
        vim.g.vimtex_view_method = 'skim'
        vim.g.vimtex_compiler_progname = 'nvr'
        vim.g.vimtex_view_skim_sync = 1
        vim.g.vimtex_view_skim_activate = 1

        vim.g.vimtex_compiler_latexmk = {
            continuous = 1,
            out_dir = 'build',
            options = {
                '-pdf',
                '-interaction=nonstopmode',
                '-synctex=1',
            },
        }

        vim.g.vimtex_quickfix_ignore_filters = {
            'Underfull',
            'Overfull',
        }
        -- Skip per-package kpsewhich lookups on startup (main source of slow .tex opens
        -- with large preambles — was taking ~4.8s on this machine).
        vim.g.vimtex_syntax_packages_default = 'nocheck'

        -- tikz/pgf are the heaviest offenders (many sub-files each) — disable their
        -- dedicated syntax loading specifically, since they contribute the most lookups.
        vim.g.vimtex_syntax_packages = {
            tikz = { load = false },
            pgf = { load = false },
        }
        vim.g.vimtex_fold_enabled = 0
        vim.g.vimtex_syntax_conceal_disable = 0
    end,
}
