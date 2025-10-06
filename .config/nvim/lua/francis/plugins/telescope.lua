return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        'nvim-tree/nvim-web-devicons',
        'folke/todo-comments.nvim',
    },
    config = function()
        local telescope = require 'telescope'
        local actions = require 'telescope.actions'
        local transform_mod = require('telescope.actions.mt').transform_mod

        local trouble = require 'trouble'
        local trouble_telescope = require 'trouble.sources.telescope'

        -- or create your custom action
        local custom_actions = transform_mod {
            open_trouble_qflist = function(prompt_bufnr)
                trouble.toggle 'quickfix'
            end,
        }

        telescope.setup {
            defaults = {
                path_display = { 'smart' },
                mappings = {
                    i = {
                        ['<C-k>'] = actions.move_selection_previous, -- move to prev result
                        ['<C-j>'] = actions.move_selection_next, -- move to next result
                        ['<C-q>'] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
                        ['<C-t>'] = trouble_telescope.open,
                        --- the problem with this was it opens a new tab every time sometime enters for telescope which is terrible
                        -- ['<CR>'] = actions.select_tab, -- Enter opens in a new tab
                        ['<C-v>'] = actions.select_vertical, -- Vertical split
                        ['<C-x>'] = actions.select_horizontal, -- Horizontal split
                    },
                },
            },
        }

        telescope.load_extension 'fzf'
        local function insert_template()
            local template_dir = vim.fn.stdpath 'config' .. '/templates/markdown'

            -- Create template dir if it doesn't exist
            vim.fn.mkdir(template_dir, 'p')

            require('telescope.builtin').find_files {
                prompt_title = 'Select Template',
                cwd = template_dir,
                attach_mappings = function(_, map)
                    map('i', '<CR>', function(prompt_bufnr)
                        local selection = require('telescope.actions.state').get_selected_entry()
                        actions.close(prompt_bufnr)

                        -- Read and insert template
                        local template = vim.fn.readfile(selection.path)
                        vim.api.nvim_buf_set_lines(0, 0, -1, false, template)

                        -- Replace date
                        local today = os.date '%Y-%m-%d'
                        vim.cmd('silent! %s/\\${\\d\\+:' .. today .. '}/' .. today .. '/ge')

                        -- Jump to first field
                        vim.cmd 'normal! gg'
                        vim.fn.search('${1:', 'c')
                    end)
                    return true
                end,
            }
        end
        -- set keymaps
        local keymap = vim.keymap -- for conciseness

        keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Fuzzy find files in cwd' })
        keymap.set('n', '<leader>fF', function()
            require('telescope.builtin').find_files { no_ignore = true, hidden = true }
        end, { desc = 'Find Files (no ignore)' })
        keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>', { desc = 'Fuzzy find recent files' })
        keymap.set('n', '<leader>fs', '<cmd>Telescope live_grep<cr>', { desc = 'Find string in cwd' })
        keymap.set('n', '<leader>fc', '<cmd>Telescope grep_string<cr>', { desc = 'Find string under cursor in cwd' })
        keymap.set('n', '<leader>ft', '<cmd>TodoTelescope keywords=TODO<cr>', { desc = 'Find todos' })
        keymap.set('n', '<leader>fx', '<cmd>TodoTelescope keywords=FIXME,HACK,TODO,NOTE,INPROGRESS,NEXT,WARN<cr>', { desc = 'Find fixme groups§' })
        keymap.set('n', '<leader>fk', '<cmd>Telescope keymaps<cr>', { desc = 'Find todos' })
        keymap.set('n', '<leader>mt', insert_template, { desc = 'Insert markdown template' })
        keymap.set('n', '<leader>fm', 'gg/^---$<CR>j', { desc = 'Jump to frontmatter' })
    end,
}
