#!/usr/bin/env bash
# Alt+Tab window switcher for Hyprland.
# Lists open windows (most-recently-used first) in rofi and focuses the choice.
THEME="$HOME/.config/rofi/themes/switcher.rasi"

mapfile -t lines < <(hyprctl clients -j | python3 -c '
import sys, json
ws = [c for c in json.load(sys.stdin) if c.get("mapped") and c.get("title")]
ws.sort(key=lambda c: c.get("focusHistoryID", 999))   # 0 = current, 1 = previous, ...
for c in ws:
    cls = c.get("class") or "?"
    print(c["address"] + ":::" + cls + "   " + c["title"])
')

(( ${#lines[@]} == 0 )) && exit 0

labels=(); addrs=()
for l in "${lines[@]}"; do
    addrs+=("${l%%:::*}")
    labels+=("${l#*:::}")
done

# -selected-row 1 pre-highlights the previously-used window (classic Alt+Tab)
idx=$(printf '%s\n' "${labels[@]}" | rofi -dmenu -i -p "Windows" \
        -format i -selected-row 1 -theme "$THEME")

# This Hyprland fork's hyprctl/IPC parses `dispatch` args as Lua, so use the
# Lua dispatcher form (plain `focuswindow address:..` errors out).
[[ -n "$idx" ]] && hyprctl dispatch "hl.dsp.focus({window=\"address:${addrs[$idx]}\"})"
