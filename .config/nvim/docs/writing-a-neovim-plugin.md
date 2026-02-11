# Writing a Neovim Plugin in Lua: A Theme Picker

This walks through how the theme picker in `colourscheme.lua` works. It's a
small, self-contained example of everything you need to write your own Neovim
functionality: data, functions, Telescope integration, keymaps, and lazy.nvim
wiring.

## Where Do Themes Come From?

Neovim themes are just plugins — GitHub repos that contain hundreds of
highlight group definitions (colors for syntax tokens, UI elements, plugin
integrations, etc.). lazy.nvim clones the repo, and then your config calls
`require('theme').setup(...)` to configure it and `vim.cmd.colorscheme('name')`
to activate it.

For example:
- **OneDark Pro** → `olimorris/onedarkpro.nvim` (GitHub repo)
- **Gruvbox** → `ellisonleao/gruvbox.nvim`
- **Catppuccin** → `catppuccin/nvim`

Each repo's README documents the available colorscheme names (e.g. catppuccin
ships four: `catppuccin-latte`, `catppuccin-frappe`, `catppuccin-macchiato`,
`catppuccin-mocha`) and the setup options (each plugin names things differently
— onedarkpro uses `transparency`, gruvbox uses `transparent_mode`, catppuccin
uses `transparent_background`). You find these by reading the repo's README.

To browse themes: https://dotfyle.com/neovim/colorscheme

## The Big Idea

A Neovim "plugin" doesn't have to be a GitHub repo. It can be a function in
your config. The theme picker is just ~70 lines of Lua that:

1. Defines a list of themes (data)
2. Writes a function to apply a theme (logic)
3. Builds a Telescope picker to choose one (UI)
4. Binds it to `<leader>cs` (keymap)

## Step 1: Define Your Data

Everything starts with a plain Lua table. Each theme has a display name, the
colorscheme command string, and an optional setup function:

```lua
local themes = {
    {
        name = 'OneDark Pro',
        colorscheme = 'onedark',
        setup = function()
            require('onedarkpro').setup { options = { transparency = true } }
        end,
    },
    {
        name = 'Gruvbox Dark Hard',
        colorscheme = 'gruvbox',
        setup = function()
            require('gruvbox').setup { contrast = 'hard', transparent_mode = true }
        end,
    },
}
```

This is the only thing you edit to add new themes. The rest of the code is
generic.

**Key Lua concept**: Tables are everything in Lua. A "list" is a table with
integer keys. A "dict/object" is a table with string keys. Both use `{}`.

## Step 2: Write the Action Function

`apply_theme()` takes a colorscheme name, finds its setup function, runs it,
then applies the colorscheme:

```lua
local function apply_theme(colorscheme)
    -- Find the matching theme entry and run its setup
    for _, t in ipairs(themes) do
        if t.colorscheme == colorscheme and t.setup then
            t.setup()
        end
    end

    -- Apply the colorscheme
    vim.cmd.colorscheme(colorscheme)

    -- Force transparent backgrounds
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
end
```

**Key Neovim APIs used**:

- `vim.cmd.colorscheme(name)` — runs `:colorscheme name` (any vim command
  can be called as `vim.cmd.commandname()`)
- `vim.api.nvim_set_hl(0, group, opts)` — sets a highlight group. The `0`
  means "global namespace". We override Normal/NormalFloat/SignColumn to force
  transparency regardless of what the theme sets.

## Step 3: Build the Telescope Picker

This is the interesting part. Telescope provides a framework for building
fuzzy-find UIs. You need 4 components:

```lua
local function pick_theme()
    local pickers = require 'telescope.pickers'
    local finders = require 'telescope.finders'
    local conf = require('telescope.config').values
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'
```

### The Picker Architecture

Telescope pickers have 3 parts:

```
┌─────────────────────────────────┐
│  prompt_title (the header)      │
├─────────────────────────────────┤
│                                 │
│  finder (generates the list)    │  ← where items come from
│                                 │
├─────────────────────────────────┤
│  sorter (filters as you type)   │  ← fuzzy matching
│                                 │
│  attach_mappings (what happens  │  ← what Enter does
│  when you press Enter)          │
└─────────────────────────────────┘
```

### The Finder: Turning Data Into Entries

`finders.new_table` takes your data and an `entry_maker` that tells Telescope
how to display each item:

```lua
finder = finders.new_table {
    results = themes,     -- our table from step 1
    entry_maker = function(entry)
        return {
            value = entry.colorscheme,                           -- what we use internally
            display = entry.name .. '  (' .. entry.colorscheme .. ')',  -- what the user sees
            ordinal = entry.name,                                -- what fuzzy search matches against
        }
    end,
},
```

Three fields matter:
- **`value`**: The data you get back when the user selects this entry
- **`display`**: The string shown in the picker list
- **`ordinal`**: The string Telescope fuzzy-matches against when you type

### The Sorter: Fuzzy Matching

```lua
sorter = conf.generic_sorter {},
```

This uses Telescope's default fuzzy sorter. You almost always want this.
(For file pickers you'd use `file_sorter` instead.)

### The Action: What Happens on Enter

`attach_mappings` lets you override what the default action (Enter) does:

```lua
attach_mappings = function(prompt_bufnr)
    actions.select_default:replace(function()
        actions.close(prompt_bufnr)                          -- close the picker
        local selection = action_state.get_selected_entry()  -- get what's highlighted
        apply_theme(selection.value)                          -- do our thing
    end)
    return true   -- return true = keep other default mappings (Esc to close, etc.)
end,
```

The key Telescope pattern:
1. `actions.close(prompt_bufnr)` — close the picker window
2. `action_state.get_selected_entry()` — get the highlighted entry
3. `selection.value` — access the `value` field from your `entry_maker`

### Putting It Together

```lua
pickers
    .new({}, {
        prompt_title = 'Pick a Colorscheme',
        finder = ...,
        sorter = ...,
        attach_mappings = ...,
    })
    :find()    -- this opens the picker
```

`pickers.new(telescope_opts, picker_opts):find()` — the first `{}` is for
Telescope-wide options (theme, layout, etc.). We pass empty to use defaults.

## Step 4: Wire It Into lazy.nvim

The `return` table at the bottom is what lazy.nvim reads. We need to:
1. Install the theme plugins (so they're available)
2. Apply the default theme on startup
3. Register the keymap

```lua
return {
    -- Install theme plugins (both loaded eagerly so they're always available)
    {
        'olimorris/onedarkpro.nvim',
        lazy = false,
        priority = 1000,
    },
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false,
        priority = 1000,
    },
    -- Hook into an already-installed plugin to run our startup code
    {
        'nvim-lua/plenary.nvim',
        priority = 999,
        config = function()
            apply_theme(default)
            vim.keymap.set('n', '<leader>cs', pick_theme, { desc = 'Pick colorscheme' })
        end,
    },
}
```

**Why `priority = 1000`?** Colorschemes must load before other plugins that
might set highlights. Higher priority = loads earlier.

**Why hook onto plenary.nvim?** We need lazy.nvim to run our `config` function
at startup. Since plenary is already installed as a dependency, we piggyback on
it. The `config` function runs our `apply_theme(default)` and registers the
keymap. Priority 999 ensures it runs right after the theme plugins (1000).

**Why `lazy = false`?** Both theme plugins need to be loaded at startup, not
deferred, since we apply the default theme immediately.

## Step 5: Register the Keymap

```lua
vim.keymap.set('n', '<leader>cs', pick_theme, { desc = 'Pick colorscheme' })
```

- `'n'` — normal mode only
- `'<leader>cs'` — Space + c + s (since leader is Space)
- `pick_theme` — the function we wrote (not a string, a direct function reference)
- `desc` — shows up in which-key and `:Telescope keymaps`

## How to Add a New Theme

1. Install the plugin — add a spec to the `return` table:
   ```lua
   { 'catppuccin/nvim', lazy = false, priority = 1000 },
   ```

2. Add a themes entry:
   ```lua
   {
       name = 'Catppuccin Mocha',
       colorscheme = 'catppuccin-mocha',
       setup = function()
           require('catppuccin').setup { transparent_background = true }
       end,
   },
   ```

3. That's it. The picker finds it automatically.

## Summary of Neovim APIs Used

| API | What It Does |
|---|---|
| `vim.cmd.colorscheme(name)` | Run any vim command as a Lua function |
| `vim.api.nvim_set_hl(0, group, opts)` | Set highlight group colors |
| `vim.keymap.set(mode, lhs, rhs, opts)` | Create a keymap |
| `require('telescope.pickers').new()` | Create a custom Telescope picker |
| `require('telescope.finders').new_table()` | Create a finder from a Lua table |
| `require('telescope.actions')` | Built-in actions (close, select, etc.) |
| `require('telescope.actions.state')` | Get the currently selected entry |

## The Pattern

Any time you want a "pick from a list" UI in Neovim, the pattern is:

1. **Data**: A Lua table of options
2. **Action**: A function that does something with the selection
3. **Picker**: `pickers.new` + `finders.new_table` + `attach_mappings`
4. **Keymap**: `vim.keymap.set` pointing to the picker function

You can use this same pattern for picking git branches, switching projects,
selecting snippets, choosing formatters — anything that's "show a list, pick
one, do something".
