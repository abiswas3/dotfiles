# dotfiles

Personal configuration for an Arch Linux + Hyprland (Wayland) setup. Configs live
under `.config/` (mirrors `~/.config`), with a few in the repo root (e.g. `.wezterm.lua`).

## Install packages

### Arch — one shot

```bash
cd ~/dotfiles
bash install/arch.sh
```

Reads `packages/arch.txt` (official repos) and `packages/aur.txt` (AUR, via
`yay`/`paru`). Uses `pacman -S --needed`, so already-current packages are left
alone, out-of-date ones are upgraded, and missing ones are installed. Safe to
re-run.

### Or by hand — official repos

```bash
sudo pacman -S --needed \
  hyprland waybar wpaperd rofi-wayland kitty zellij fish starship \
  btop htop bat eza neovim nwg-look pavucontrol qt6ct gtk3 gtk4 nemo \
  chromium playerctl bluetui git \
  mako hyprlock hypridle hyprpolkitagent grim slurp wl-clipboard cliphist brightnessctl
```

### AUR (via yay)

```bash
yay -S --needed nmrs neofetch sioyek
```

> `wezterm` is also in the repos (`sudo pacman -S wezterm`) — its config
> (`.wezterm.lua`) is kept here, but the active terminal is `kitty`.
> `rofi-wayland` is the Wayland build; use plain `rofi` on X11.

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
| `kitty/`                    | kitty          | repo   | Terminal (cross-platform; current default) |
| `nwg-look/`, `qt6ct/`, `gtk-3.0/`, `gtk-4.0/`, `xsettingsd/`, `kdeglobals` | nwg-look, qt6ct | repo | GTK/Qt/KDE theming |
| `pavucontrol.ini`           | pavucontrol    | repo   | Audio mixer |
| `nemo/`                     | nemo           | repo   | File manager |
| `nmrs/`                     | nmrs           | AUR    | (TUI; ships `style.css`) |
| `sioyek/`                   | sioyek         | AUR    | PDF reader (papers) |
| `neofetch/`                 | neofetch       | AUR    | System info display |
| `mimeapps.list`             | —              | —      | Default-application associations |
| `.wezterm.lua` (root)       | wezterm        | repo   | Kept; migrating to kitty/zellij everywhere |
| `git/`                      | git            | repo   | Git config |
| `uv/`                       | uv             | repo   | Python tooling |

## Hyprland runtime daemons & tools

These have no (or minimal) config of their own — they're the moving parts that
make the Wayland session behave like the old i3 setup. The four daemons are
autostarted from `hypr/hyprland.lua` (`hyprland.start`).

| Tool              | Why it's here |
|-------------------|---------------|
| `mako`            | Notification daemon — shows app/desktop notifications (no notifier runs without it) |
| `hypridle`        | Idle daemon — locks, blanks displays, then suspends after timeouts (config: `hypr/hypridle.conf`) |
| `hyprlock`        | Lock screen invoked on idle/suspend/manual lock (config: `hypr/hyprlock.conf`) |
| `hyprpolkitagent` | Polkit agent for GUI password/privilege prompts (started via `systemctl --user`) |
| `grim` + `slurp`  | Screenshots — `grim` captures, `slurp` selects a region; bound to the `Print` keys |
| `wl-clipboard`    | `wl-copy`/`wl-paste` — clipboard plumbing for screenshots and clipboard history |
| `cliphist`        | Clipboard history, browsed via rofi (`Alt+Shift+C`) |
| `brightnessctl`   | Backlight control for the `XF86MonBrightness` keys |
| `playerctl`       | Media-key control (play/pause/next/prev) |
| `bluetui`         | Bluetooth manager (TUI) — replaces the X11 `blueman-applet` tray |
| `nmrs`            | NetworkManager manager (TUI, AUR) — replaces the `nm-applet` tray |

> Wallpaper lives at `~/Pictures/wallpapers/` and is set in `wpaperd/config.toml`.

## Notes

- Some keybinds/scripts reference tools not currently installed (e.g.
  `brightnessctl`, `xsettingsd`); install them if you use those bindings.
- `kitty` is the terminal launched by Hyprland (`SUPER+T`); its config lives in
  `kitty/kitty.conf`. `wezterm` config is kept for now but being phased out in
  favour of kitty + zellij across machines.
- Cross-platform configs (`fish`, `btop`, `kitty`, `starship`, `zellij`, …) are
  written to work on both macOS and Linux. Machine-specific bits — `PATH`
  entries and per-machine overrides — live in fish *universal* variables
  (`fish_variables`, gitignored), not in the tracked `config.fish`.
- Excluded from the repo on purpose (not portable / contain secrets / machine
  state): browser profile (`chromium`), `pulse`, `dconf`, `go`, `yay` caches,
  `okularrc`, `QtProject.conf`.
