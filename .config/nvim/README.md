# Neovim Configuration

## How It Works

### Entry Point

Neovim reads `init.lua` on startup. This file does two things:

```
init.lua
  -> require("francis.core")    -- editor options + keymaps
  -> require("francis.lazy")    -- bootstrap lazy.nvim + load all plugins
```

### Directory Structure

```
~/.config/nvim/
├── init.lua                      # Entry point
├── lazy-lock.json                # Pinned plugin versions (auto-generated)
├── .stylua.toml                  # Lua formatter config
│
├── lua/francis/
│   ├── core/
│   │   ├── init.lua              # Loads options.lua and keymaps.lua
│   │   ├── options.lua           # Editor settings (tabs, search, colors, etc.)
│   │   └── keymaps.lua           # Global keymaps (leader, splits, tasks, pandoc)
│   │
│   ├── lazy.lua                  # Bootstraps lazy.nvim plugin manager
│   │
│   ├── plugins/                  # Each file returns a lazy.nvim plugin spec
│   │   ├── init.lua              # Base deps (plenary.nvim)
│   │   ├── alpha.lua             # Startup dashboard
│   │   ├── auto-sessions.lua     # Session save/restore
│   │   ├── buffer_line.lua       # Tab bar
│   │   ├── cmp.lua               # Autocompletion engine
│   │   ├── colourscheme.lua      # OneDark Pro theme
│   │   ├── css-colours.lua       # Inline color previews
│   │   ├── dressing.lua          # Better UI for inputs and selections
│   │   ├── file_explorer.lua     # nvim-tree sidebar
│   │   ├── formatting.lua        # Format-on-save (prettier, stylua)
│   │   ├── gitsigns.lua          # Git gutter signs + vim-fugitive
│   │   ├── indent.lua            # Indent guide lines
│   │   ├── lualine.lua           # Statusline
│   │   ├── markdown.lua          # Markdown rendering
│   │   ├── neogen.lua            # Docstring generation
│   │   ├── pencil.lua            # Soft-wrap for writing
│   │   ├── snipetts.lua          # LuaSnip custom snippets
│   │   ├── split-maximise.lua    # Maximize/restore splits
│   │   ├── substitute.lua        # Substitute-with-motion operator
│   │   ├── surround.lua          # Add/change/delete surrounding pairs
│   │   ├── telescope.lua         # Fuzzy finder
│   │   ├── todo.lua              # TODO/DONE/FIXME highlighting
│   │   ├── tree-sitter.lua       # Syntax/indent via AST + theorem highlights
│   │   ├── trouble.lua           # Diagnostics viewer
│   │   ├── typst_preview.lua     # Typst live preview + syntax
│   │   ├── vimtex.lua            # LaTeX support
│   │   ├── whichkey.lua          # Keymap popup hints
│   │   └── zenmode.lua           # Distraction-free writing
│   │
│   │   └── lsp/                  # Language-specific LSP configs
│   │       ├── lspconfig.lua     # Core LSP keymaps + diagnostics
│   │       ├── mason.lua         # LSP/tool installer
│   │       ├── rust.lua          # Rust (rustaceanvim and crates)
│   │       ├── lean.lua          # Lean 4 theorem prover
│   │       ├── doc-symbols.lua   # Aerial symbol outline
│   │       └── lazy_git.lua      # LazyGit floating window
│   │
├── after/syntax/
│   └── markdown.vim              # Additional markdown syntax rules
│
├── spell/                        # Spell check dictionary
│
└── templates/markdown/           # Markdown templates for <leader>mt
    ├── blog.md
    └── project.md
```

### How lazy.nvim Discovers Plugins

In `lazy.lua`, the setup call uses `import`:

```lua
require("lazy").setup({
    { import = "francis.plugins" },
    { import = "francis.plugins.lsp" },
})
```

This tells lazy.nvim to **automatically require every `.lua` file** in those
directories. Each file must return a table (or list of tables) conforming to
the lazy.nvim plugin spec format:

```lua
-- Example: plugins/surround.lua
return {
    "kylechui/nvim-surround",  -- GitHub repo
    config = true,             -- call setup() with defaults
}
```

Key lazy.nvim concepts used here:

- **`event`**: Lazy-load the plugin when this event fires (e.g. `BufReadPre`)
- **`ft`**: Lazy-load only for specific filetypes (e.g. `rust`, `typst`)
- **`cmd`**: Lazy-load when a vim command is first run
- **`keys`**: Lazy-load when a keymap is first pressed
- **`dependencies`**: Other plugins that must load first
- **`config`**: Function or `true` to call `require("plugin").setup()`
- **`opts`**: Table passed to `setup()` (shorthand for simple configs)
- **`build`**: Shell command or function to run after install/update
- **`priority`**: Load order (higher = earlier, used for colorschemes)

### Plugins

The 53 repositories below are the enabled plugin specs and their dependencies;
`lazy-lock.json` records their resolved version pins, and commented-out plugin
candidates are excluded.

- [`L3MON4D3/LuaSnip`](https://github.com/L3MON4D3/LuaSnip) expands and navigates code snippets.
- [`stevearc/aerial.nvim`](https://github.com/stevearc/aerial.nvim) displays a document-symbol outline.
- [`goolord/alpha-nvim`](https://github.com/goolord/alpha-nvim) provides the startup dashboard.
- [`rmagatti/auto-session`](https://github.com/rmagatti/auto-session) saves and restores sessions by working directory.
- [`akinsho/bufferline.nvim`](https://github.com/akinsho/bufferline.nvim) renders the tab bar.
- [`hrsh7th/cmp-nvim-lsp`](https://github.com/hrsh7th/cmp-nvim-lsp) exposes LSP completion capabilities to nvim-cmp.
- [`hrsh7th/cmp-omni`](https://github.com/hrsh7th/cmp-omni) adds Vim's omni-completion as a completion source.
- [`hrsh7th/cmp-path`](https://github.com/hrsh7th/cmp-path) completes filesystem paths in nvim-cmp.
- [`saadparwaiz1/cmp_luasnip`](https://github.com/saadparwaiz1/cmp_luasnip) makes LuaSnip snippets available to nvim-cmp.
- [`stevearc/conform.nvim`](https://github.com/stevearc/conform.nvim) formats buffers on demand and on save.
- [`saecki/crates.nvim`](https://github.com/saecki/crates.nvim) shows and completes Cargo crate information in TOML files.
- [`hat0uma/csvview.nvim`](https://github.com/hat0uma/csvview.nvim) formats CSV files for easier viewing and navigation.
- [`stevearc/dressing.nvim`](https://github.com/stevearc/dressing.nvim) improves Neovim input and selection prompts.
- [`rafamadriz/friendly-snippets`](https://github.com/rafamadriz/friendly-snippets) provides a community snippet collection.
- [`lewis6991/gitsigns.nvim`](https://github.com/lewis6991/gitsigns.nvim) adds Git change indicators and hunk actions.
- [`lukas-reineke/indent-blankline.nvim`](https://github.com/lukas-reineke/indent-blankline.nvim) draws indentation guides.
- [`folke/lazy.nvim`](https://github.com/folke/lazy.nvim) installs, pins, and lazy-loads the plugin set.
- [`kdheepak/lazygit.nvim`](https://github.com/kdheepak/lazygit.nvim) opens LazyGit inside Neovim.
- [`Julian/lean.nvim`](https://github.com/Julian/lean.nvim) integrates the Lean 4 language server and goal view.
- [`onsails/lspkind.nvim`](https://github.com/onsails/lspkind.nvim) adds kind icons to completion entries.
- [`nvim-lualine/lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim) renders the statusline.
- [`williamboman/mason-lspconfig.nvim`](https://github.com/williamboman/mason-lspconfig.nvim) connects Mason-installed language servers to nvim-lspconfig.
- [`WhoIsSethDaniel/mason-tool-installer.nvim`](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) installs configured external development tools through Mason.
- [`williamboman/mason.nvim`](https://github.com/williamboman/mason.nvim) manages external LSP servers, formatters, and debuggers.
- [`nvim-mini/mini.icons`](https://github.com/nvim-mini/mini.icons) supplies file and UI icons.
- [`folke/neodev.nvim`](https://github.com/folke/neodev.nvim) configures Lua development support for Neovim APIs.
- [`danymat/neogen`](https://github.com/danymat/neogen) generates documentation-comment templates.
- [`hrsh7th/nvim-cmp`](https://github.com/hrsh7th/nvim-cmp) is the completion-menu engine.
- [`antosha417/nvim-lsp-file-operations`](https://github.com/antosha417/nvim-lsp-file-operations) notifies language servers about file moves and renames.
- [`neovim/nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) configures Neovim's built-in LSP client.
- [`kylechui/nvim-surround`](https://github.com/kylechui/nvim-surround) adds, changes, and deletes surrounding pairs.
- [`nvim-tree/nvim-tree.lua`](https://github.com/nvim-tree/nvim-tree.lua) provides the file-explorer sidebar.
- [`nvim-treesitter/nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter) supplies parser-based highlighting and indentation.
- [`nvim-treesitter/nvim-treesitter-textobjects`](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) adds syntax-aware text objects and motions.
- [`nvim-tree/nvim-web-devicons`](https://github.com/nvim-tree/nvim-web-devicons) supplies file-type icons for other plugins.
- [`navarasu/onedark.nvim`](https://github.com/navarasu/onedark.nvim) applies the OneDark colour scheme.
- [`nvim-lua/plenary.nvim`](https://github.com/nvim-lua/plenary.nvim) provides common Lua utility functions for plugins.
- [`MeanderingProgrammer/render-markdown.nvim`](https://github.com/MeanderingProgrammer/render-markdown.nvim) visually renders Markdown while editing.
- [`rust-lang/rust.vim`](https://github.com/rust-lang/rust.vim) adds Rust filetype support and rustfmt integration.
- [`mrcjkb/rustaceanvim`](https://github.com/mrcjkb/rustaceanvim) configures Rust Analyzer and Rust debugging support.
- [`gbprod/substitute.nvim`](https://github.com/gbprod/substitute.nvim) replaces text using motions and selections.
- [`nvim-telescope/telescope-fzf-native.nvim`](https://github.com/nvim-telescope/telescope-fzf-native.nvim) accelerates Telescope sorting with native FZF.
- [`nvim-telescope/telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim) provides fuzzy finding for files, text, and LSP data.
- [`folke/todo-comments.nvim`](https://github.com/folke/todo-comments.nvim) highlights and searches TODO-style annotations.
- [`folke/trouble.nvim`](https://github.com/folke/trouble.nvim) presents diagnostics, quickfix items, and lists in a panel.
- [`chomosuke/typst-preview.nvim`](https://github.com/chomosuke/typst-preview.nvim) provides live previews for Typst documents.
- [`kaarmu/typst.vim`](https://github.com/kaarmu/typst.vim) provides Typst filetype detection and syntax support.
- [`tpope/vim-fugitive`](https://github.com/tpope/vim-fugitive) adds Git commands and views to Vim.
- [`szw/vim-maximizer`](https://github.com/szw/vim-maximizer) maximizes and restores the current split.
- [`preservim/vim-pencil`](https://github.com/preservim/vim-pencil) configures soft wrapping and prose-oriented editing.
- [`lervag/vimtex`](https://github.com/lervag/vimtex) provides LaTeX editing, compilation, and PDF synchronization.
- [`folke/which-key.nvim`](https://github.com/folke/which-key.nvim) shows available keybindings in a popup.
- [`folke/zen-mode.nvim`](https://github.com/folke/zen-mode.nvim) provides a distraction-free writing layout.

### Language Servers and External Tools

Neovim's built-in [LSP client](https://neovim.io/doc/user/lsp.html) provides
the client implementation; this configuration uses
[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) for server
definitions.

#### Rust

[Rustaceanvim](https://github.com/mrcjkb/rustaceanvim/blob/main/doc/rustaceanvim.txt)
starts Rust Analyzer from the explicit Rustup path
`~/.cargo/bin/rust-analyzer`, rather than from Mason. This keeps the server
aligned with the active Rust toolchain, as Rustaceanvim recommends. Rust
Analyzer is installed with `rustup component add rust-analyzer`; see the
[official Rust Analyzer installation instructions](https://rust-analyzer.github.io/book/rust_analyzer_binary.html).

Rustaceanvim is configured in the plugin's `init` phase because its
`vim.g.rustaceanvim` options must exist before Rust filetype handling begins.
Rust debugging is deliberately not installed: `nvim-dap`, its UI, and the
CodeLLDB adapter have been removed without affecting Rust LSP features.

To inspect Rust LSP, open a `.rs` file in a Cargo project and run:

```vim
:checkhealth rustaceanvim
:checkhealth vim.lsp
:lua for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do print(client.name, vim.inspect(client.config.cmd), client.config.root_dir) end
:RustLsp logFile
```

The client should be named `rust-analyzer`, use
`~/.cargo/bin/rust-analyzer`, and have the directory containing `Cargo.toml`
as its root. In a terminal, `rust-analyzer --version` checks the installed
Rustup component. Standalone Rust files have limited Rust Analyzer support;
use a Cargo project for a meaningful check.

#### Mason-managed tools

[Mason](https://github.com/mason-org/mason.nvim) is instructed to ensure the
following tools are installed:

- `lua_ls`, `html`, and [Tinymist](https://github.com/Myriad-Dreamin/tinymist) for LSP.
- `prettier` and `eslint_d` for Conform formatting.

[mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim) is
explicitly restricted to auto-enable only those three language servers, so an
old package left in Mason's data directory cannot silently start an LSP client.
Use `:Mason` to inspect or deliberately change that managed set.

#### Lean, Typst, and LaTeX

[lean.nvim](https://github.com/Julian/lean.nvim) manages Lean's `leanls`
integration independently of Mason. Typst uses the Mason-managed Tinymist
server alongside the [Typst preview plugin](https://github.com/chomosuke/typst-preview.nvim).
LaTeX editing and compilation use [VimTeX](https://github.com/lervag/vimtex);
the configured [TexLab](https://github.com/latex-lsp/texlab) settings are not
currently active because TexLab is neither installed by Mason nor explicitly
enabled.

### How Files Find Each Other

1. `init.lua` uses `require("francis.core")` which resolves to `lua/francis/core/init.lua`
2. That file requires `francis.core.options` and `francis.core.keymaps`
3. `init.lua` then requires `francis.lazy` which bootstraps the plugin manager
4. lazy.nvim scans `lua/francis/plugins/*.lua` and `lua/francis/plugins/lsp/*.lua`
5. Each plugin file is independent -- it returns its own spec and lazy.nvim handles loading order via `dependencies` and `priority`

### Key Keymaps

Leader key is **Space**.

| Keymap | Action |
|---|---|
| `jk` | Exit insert mode |
| `<leader>ff` | Find files |
| `<leader>fs` | Live grep |
| `<leader>ee` | Toggle file explorer |
| `<leader>lg` | Open LazyGit |
| `gd` | Go to definition (via Telescope) |
| `gR` | Show references (via Telescope) |
| `K` | Hover documentation |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |
| `[d` / `]d` | Previous/next diagnostic |
| `<leader>pp` | ZenMode + Pencil (writing mode) |
| `<leader>cp` | Compile markdown to HTML (Pandoc) |
| `<leader>tt` | Cycle TODO keywords |
| `<leader>td` | Mark task DONE with timestamp |
| `<leader>so` | Toggle symbol outline |
| `<leader>fk` | Show all keymaps |
