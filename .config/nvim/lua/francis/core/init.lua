require("francis.core.options")
require("francis.core.keymaps")

-- Disable native rust_analyzer early — rustaceanvim manages it.
-- Must run before any Rust buffer is opened to prevent a duplicate LSP client.
vim.lsp.enable('rust_analyzer', false)
