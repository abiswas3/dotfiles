-- install with yarn or npm
return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
  config = function()
    vim.g.mkdp_theme = 'dark'
    vim.g.mkdp_preview_options = {
      katex = {}, -- KaTeX options for math rendering
    }
  vim.g.mkdp_markdown_css = '/Users/aribiswas3/on-a-tangent/css/combined.css'

  end,
}

