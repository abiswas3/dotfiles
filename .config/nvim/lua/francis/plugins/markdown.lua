return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' }, -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            callouts = {
                remark = {
                    -- Match pandoc fenced divs like ::: {.remark}
                    match = '^::: ?{%.remark}',

                    -- Optional title shown in rendered buffer
                    title = 'Remark',

                    -- Icon in front of the title
                    icon = '',

                    -- Highlight group for border/title/icon
                    highlight = 'RenderMarkdownInfo',

                    -- How the block is closed
                    end_match = '^:::$',
                },
            },
        },
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
    },
}
