# Neovim Config Changelog

## 2026-02-10

### Snippets: moved from Lua to JSON
- Created `snippets/` directory with VS Code-style JSON snippet files
- `snippets/markdown.json` — all custom markdown snippets (post, meeting, box, def, thm, lemma, remark, cor)
- `snippets/package.json` — maps JSON files to languages
- `lua/francis/plugins/snipetts.lua` — removed hardcoded Lua snippets, added second `lazy_load` pointing at `snippets/` directory
- To add new snippets: edit the JSON files directly, no Lua needed

### Snippets: added `box` shortcode
- New `box` trigger expands to `{% theorem(type="box") %}...{% end %}`

### Syntax: Zola shortcode block highlighting
- `after/syntax/markdown.vim` — added `syntax region` for `{% theorem(...) %}...{% end %}` blocks
- Entire block gets a subtle background highlight (like code fences / blockquotes)
- Delimiter lines shown in muted text
