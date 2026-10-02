return {
  dir = "/Users/francis/Projects/zola-nvim-client",
  lazy = false,
  config = function()
    require("zola_nvim_client").setup({
      command = "/Users/francis/Projects/zola-lsp/target/debug/zola-lsp",
      content_root = "/Users/francis/Websites/WorkingNotes/content/blog",
    })
  end,
}
