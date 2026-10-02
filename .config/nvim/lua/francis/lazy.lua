-- This file bootstraps and configures lazy.nvim, the plugin manager used by
-- this Neovim configuration. It runs once during every Neovim startup.

-- Ask Neovim for its data directory (normally ~/.local/share/nvim), then form
-- the location where Lazy itself is installed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Inspect that directory. `fs_stat` returns nil when Lazy has not yet been
-- installed, such as on a new machine or after deleting the checkout.
if not vim.uv.fs_stat(lazypath) then
  -- Run an external command synchronously to download Lazy's source code.
  vim.fn.system({
    -- Use Git to download the repository.
    "git",
    -- Clone makes a local checkout of a remote Git repository.
    "clone",
    -- Avoid downloading old file versions; this makes the initial clone smaller.
    "--filter=blob:none",
    -- This is Lazy's actual GitHub repository, maintained by folke.
    "https://github.com/folke/lazy.nvim.git",
    -- Install Lazy's stable branch instead of its development branch.
    "--branch=stable",
    -- Put the downloaded repository at the location calculated above.
    lazypath,
  })
end

-- Put Lazy's directory at the front of Neovim's runtime path. This makes
-- `require("lazy")` find Lazy's Lua code on the next line.
vim.opt.rtp:prepend(lazypath)

-- Load Lazy's Lua module and give it the complete plugin specification.
require("lazy").setup({
  -- Import every plugin-specification Lua file below lua/francis/plugins/.
  { import = "francis.plugins" },
  -- Also import every plugin-specification Lua file below lua/francis/plugins/lsp/.
  { import = "francis.plugins.lsp" },
}, {
  -- Configure Lazy's background update checker.
  checker = {
    -- Periodically check whether installed GitHub plugins have updates.
    enabled = true,
    -- Do not show a notification when Lazy finds an update.
    notify = false,
  },
  -- Configure what happens when plugin files change on disk while Neovim runs.
  change_detection = {
    -- Do not show a notification merely because Lazy noticed such a change.
    notify = false,
  },
})
