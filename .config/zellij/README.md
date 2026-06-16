# Zellij cheat sheet

**Leader = `Ctrl+q`** (tmux-style prefix). Press the leader, release, then press the key below.
Pane keys mirror the old wezterm setup; everything else follows tmux conventions.

## Panes
| Keys | Description |
|------|-------------|
| `Ctrl+q` `=` | Split side-by-side (new pane to the right). Alias: `%` |
| `Ctrl+q` `-` | Split stacked (new pane below). Alias: `"` |
| `Ctrl+q` `h` `j` `k` `l` | Move focus left / down / up / right |
| `Ctrl+q` `o` | Cycle focus to next pane |
| `Ctrl+q` `←` `↓` `↑` `→` | Resize the focused pane |
| `Ctrl+q` `x` | Close the focused pane |
| `Ctrl+q` `z` | Toggle zoom / fullscreen the focused pane |

## Tabs
| Keys | Description |
|------|-------------|
| `Ctrl+q` `c` | New tab |
| `Ctrl+q` `n` / `p` | Next / previous tab |
| `Ctrl+q` `1`–`9` | Jump to tab number |
| `Ctrl+q` `,` | Rename current tab |

## Sessions
| Keys | Description |
|------|-------------|
| `Ctrl+q` `d` | Detach (leave session running in the background) |
| `Ctrl+q` `$` | Rename the current session |
| `Ctrl+q` `s` | Open the session manager (list / switch / rename) |
| `Ctrl+q` `q` | Quit (kill the current session) |

## Other
| Keys | Description |
|------|-------------|
| `Ctrl+q` `[` | Enter scroll / copy mode (`Esc` to exit) |
| `Ctrl+q` `space` | Cycle layout (swap layout) |
| `Ctrl+q` `Ctrl+q` | Send a literal `Ctrl+q` to the shell |

## From the command line
| Command | Description |
|---------|-------------|
| `zellij` | Start a new session |
| `zellij attach <name>` | Re-attach to a running/detached session |
| `zellij ls` | List sessions |
| `zellij kill-session <name>` | Kill a running session |
| `zellij kill-all-sessions` | Kill every running session |
| `zellij delete-session <name>` | Remove an exited session from the list |
| `zellij action rename-session <name>` | Rename the current session |

## Notes
- Config lives in this directory: `config.kdl`. Changes apply to **new** sessions.
- No conflict with Hyprland — Hyprland binds use `SUPER`; zellij uses `Ctrl`/`Alt`.
- Built-in zellij mode switches still work too: `Ctrl+p` (pane), `Ctrl+t` (tab),
  `Ctrl+n` (resize), `Ctrl+s` (scroll), `Ctrl+o` (session), `Ctrl+g` (lock).
