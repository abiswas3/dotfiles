-- markdown-preview.nvim: browser-based GitHub-styled live preview.
-- Renders shields.io badges, KaTeX, mermaid; syncs with the buffer.
return {
    -- 'iamcco/markdown-preview.nvim',
    -- cmd = { 'MarkdownPreview', 'MarkdownPreviewStop', 'MarkdownPreviewToggle' },
    -- ft = { 'markdown' },
    -- -- Build via shell: the plugin's mkdp#util#install vim function isn't
    -- -- sourced when lazy.nvim runs `build`, so call yarn directly.
    -- build = 'cd app && npx --yes yarn install',
    -- init = function()
    --     vim.g.mkdp_filetypes = { 'markdown' }
    -- end,
    -- config = function()
    --     vim.g.mkdp_auto_close = 1
    --     vim.g.mkdp_theme = 'light' -- or 'dark' to match your colourscheme
    --     -- :MarkdownPreviewToggle  → open/close in browser
    -- end,
}
