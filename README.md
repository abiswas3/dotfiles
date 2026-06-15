# dotfiles

Personal configuration for an Arch Linux + Hyprland (Wayland) setup. Configs live
under `.config/` (mirrors `~/.config`), with a few in the repo root (e.g. `.wezterm.lua`).

## Install packages

### Current setup (Wayland / Hyprland) — official repos

```bash
sudo pacman -S --needed \
  hyprland waybar wpaperd rofi-wayland kitty zellij fish starship \
  btop htop neovim nwg-look pavucontrol qt6ct nemo chromium \
  playerctl bluetui git
```

### AUR (via yay)

```bash
yay -S --needed nmrs
```

> `wezterm` is also in the repos (`sudo pacman -S wezterm`) — its config
> (`.wezterm.lua`) is kept here, but the active terminal is `kitty`.
> `rofi-wayland` is the Wayland build; use plain `rofi` on X11.

### Legacy (X11 / i3) — configs present, not currently installed

These cover the older i3/X11 environment. Install only if reviving that setup:

```bash
sudo pacman -S --needed i3-wm i3blocks picom polybar sxhkd
```

### Optional tools (configs present)

```bash
sudo pacman -S --needed uv        # Python package manager (Astral)
# moccasin — Vyper dev framework, install via: uv tool install moccasin
```

## What each config is for

| Config (`.config/…`)        | Package        | Source | Notes |
|-----------------------------|----------------|--------|-------|
| `hypr/`                     | hyprland       | repo   | Wayland compositor (config in Lua) |
| `waybar/`                   | waybar         | repo   | Status bar |
| `wpaperd/`                  | wpaperd        | repo   | Wallpaper daemon |
| `rofi/`                     | rofi-wayland   | repo   | App launcher / menus (+ wifi menu script) |
| `zellij/`                   | zellij         | repo   | Terminal multiplexer (leader = `Ctrl+q`) |
| `fish/`                     | fish           | repo   | Shell |
| `starship.toml`             | starship       | repo   | Shell prompt |
| `btop/`, `htop/`            | btop, htop     | repo   | System monitors |
| `nvim/`                     | neovim         | repo   | Editor (symlinked) |
| `nwg-look/`, `qt6ct/`, `gtk-3.0/`, `gtk-4.0/`, `xsettingsd/` | nwg-look, qt6ct | repo | GTK/Qt theming |
| `pavucontrol.ini`           | pavucontrol    | repo   | Audio mixer |
| `nemo/`                     | nemo           | repo   | File manager |
| `nmrs/`                     | nmrs           | AUR    | (TUI; ships `style.css`) |
| `mimeapps.list`             | —              | —      | Default-application associations |
| `.wezterm.lua` (root)       | wezterm        | repo   | Kept; superseded by kitty |
| `i3/`, `i3blocks/`, `picom/`, `polybar/`, `sxhkd/` | (legacy) | repo | Old X11/i3 environment |
| `git/`                      | git            | repo   | Git config |
| `uv/`                       | uv             | repo   | Python tooling |

## Notes

- Some keybinds/scripts reference tools not currently installed (e.g.
  `brightnessctl`, `xsettingsd`); install them if you use those bindings.
- `kitty` has no custom config here — it runs on defaults and is the terminal
  launched by Hyprland (`SUPER+T`).
- Excluded from the repo on purpose (not portable / contain secrets): browser
  profile (`chromium`), `pulse`, `dconf`, `go`, `yay` caches.
