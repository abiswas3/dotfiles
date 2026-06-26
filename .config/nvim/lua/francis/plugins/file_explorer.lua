-- nvim-tree: File explorer sidebar with git status icons and diagnostics.
-- <leader>ee toggles, <leader>ef finds current file, <leader>ec collapses all.
return {
    'nvim-tree/nvim-tree.lua',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        local nvimtree = require 'nvim-tree'

        -- Disable netrw (vim's built-in file explorer) to avoid conflicts
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        nvimtree.setup {
            view = {
                -- Responsive width: ~30% of the editor, clamped so it stays
                -- usable on small screens yet never wider than the old 50.
                -- Evaluated each time the tree opens, so it adapts per session.
                width = 30,
                relativenumber = true,
            },
            renderer = {
                indent_markers = { enable = true },
                icons = {
                    glyphs = {
                        folder = {
                            arrow_closed = '',
                            arrow_open = '',
                        },
                        default = '󱓻',
                        symlink = '󱓻',
                        bookmark = '',
                        modified = '',
                        hidden = '󱙝',
                        git = {
                            unstaged = '❓',
                            staged = '✅',
                            unmerged = '⚠️',
                            untracked = '🆕',
                            renamed = '🔀',
                            deleted = '🗑️',
                            ignored = '🙈',
                        },
                    },
                },
            },
            diagnostics = {
                enable = true,
                show_on_dirs = true,
                icons = {
                    hint = 'Hint',
                    info = 'Info',
                    warning = 'Warn',
                    error = 'Err',
                },
            },
            -- Disable window_picker so files open in the expected split
            actions = {
                open_file = {
                    window_picker = { enable = false },
                },
            },
            filters = {
                custom = { '.DS_Store' },
            },
            git = {
                ignore = false,
            },
        }

        local keymap = vim.keymap
        keymap.set('n', '<leader>ee', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
        keymap.set('n', '<leader>ef', '<cmd>NvimTreeFindFileToggle<CR>', { desc = 'Toggle file explorer on current file' })
        keymap.set('n', '<leader>ec', '<cmd>NvimTreeCollapse<CR>', { desc = 'Collapse file explorer' })
        keymap.set('n', '<leader>er', '<cmd>NvimTreeRefresh<CR>', { desc = 'Refresh file explorer' })
    end,
}
