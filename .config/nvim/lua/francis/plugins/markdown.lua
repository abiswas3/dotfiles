-- render-markdown: Renders markdown with nice formatting in normal mode.
-- Headings, lists, code blocks, etc. get visual treatment while editing.
return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },
    opts = {
        render_modes = { 'n', 'c', 't' },
    },
}
