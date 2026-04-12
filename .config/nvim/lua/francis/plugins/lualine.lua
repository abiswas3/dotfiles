-- Lualine: Custom statusline at the bottom of the editor.
-- Shows mode, git branch, diff stats, diagnostics, filename (absolute path),
-- lazy.nvim update count, encoding, filetype, and cursor position.
return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local lualine = require 'lualine'
        local lazy_status = require 'lazy.status'

        local colors = {
            blue = '#65D1FF',
            green = '#3EFFDC',
            violet = '#FF61EF',
            yellow = '#FFDA7B',
            red = '#FF4A4A',
            fg = '#c3ccdc',
            bg = '#112638',
            inactive_bg = '#2c3043',
        }

        local my_lualine_theme = {
            normal = {
                a = { bg = colors.blue, fg = colors.bg, gui = 'bold' },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            insert = {
                a = { bg = colors.green, fg = colors.bg, gui = 'bold' },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            visual = {
                a = { bg = colors.violet, fg = colors.bg, gui = 'bold' },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            command = {
                a = { bg = colors.yellow, fg = colors.bg, gui = 'bold' },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            replace = {
                a = { bg = colors.red, fg = colors.bg, gui = 'bold' },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            inactive = {
                a = { bg = colors.inactive_bg, fg = colors.fg, gui = 'bold' },
                b = { bg = colors.inactive_bg, fg = colors.fg },
                c = { bg = colors.inactive_bg, fg = colors.fg },
            },
        }

        lualine.setup {
            options = {
                theme = my_lualine_theme,
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = {
                    {
                        'filename',
                        path = 2, -- absolute path
                        shorting_target = 40,
                    },
                },
                lualine_x = {
                    {
                        function()
                            local path = vim.fn.expand '%:p'
                            if path == '' then return '' end
                            local parts = vim.split(path, '/', { trimempty = true })
                            if #parts <= 4 then return path end
                            local tail = table.concat(vim.list_slice(parts, #parts - 3), '/')
                            local avail = vim.o.columns - 80
                            if #tail > avail then
                                return parts[#parts]
                            end
                            return '.../' .. tail
                        end,
                        color = { fg = '#65D1FF' },
                    },
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                        color = { fg = '#ff9e64' },
                    },
                    { 'encoding' },
                    { 'fileformat' },
                    { 'filetype' },
                },
                lualine_y = { 'progress' },
                lualine_z = { 'location' },
            },
        }
    end,
}
