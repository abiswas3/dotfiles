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
│   │   ├── dressing.lua          # Better UI for inputs/selects + calendar
│   │   ├── file_explorer.lua     # nvim-tree sidebar
│   │   ├── formatting.lua        # Format-on-save (prettier, stylua, black)
│   │   ├── gitsigns.lua          # Git gutter signs + vim-fugitive
│   │   ├── indent.lua            # Indent guide lines
│   │   ├── lualine.lua           # Statusline
│   │   ├── markdown.lua          # Markdown rendering
│   │   ├── neogen.lua            # Docstring generation
│   │   ├── pencil.lua            # Soft-wrap for writing
│   │   ├── snacks.lua            # Utility deps (nui, luatz, luarocks)
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
│   │       ├── rust.lua          # Rust (rustaceanvim, DAP, crates)
│   │       ├── python-go.lua     # Python (neogen/numpydoc) + Go (vim-go)
│   │       ├── lean.lua          # Lean 4 theorem prover
│   │       ├── doc-symbols.lua   # Aerial symbol outline
│   │       └── lazy_git.lua      # LazyGit floating window
│   │
│   └── custom/                   # Custom Lua modules (not plugins)
│       ├── meeting.lua           # Meeting creator with calendar + timezone
│       ├── calendar.lua          # Floating calendar picker
│       ├── timepicker.lua        # Time input with timezone conversion
│       └── contacts.lua          # Telescope-based contact picker
│
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

### How Files Find Each Other

1. `init.lua` uses `require("francis.core")` which resolves to `lua/francis/core/init.lua`
2. That file requires `francis.core.options` and `francis.core.keymaps`
3. `init.lua` then requires `francis.lazy` which bootstraps the plugin manager
4. lazy.nvim scans `lua/francis/plugins/*.lua` and `lua/francis/plugins/lsp/*.lua`
5. Each plugin file is independent -- it returns its own spec and lazy.nvim handles loading order via `dependencies` and `priority`
6. The `custom/` directory is **not** auto-loaded by lazy.nvim -- those modules are loaded on-demand via `require("francis.custom.xxx")` in keymaps

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
