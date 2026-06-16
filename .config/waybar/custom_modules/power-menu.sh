#!/usr/bin/env bash
# Rofi power menu (launched from the waybar power icon).
# Uses systemctl/loginctl/hyprctl directly (hyprshutdown is not installed).

chosen=$(printf '%s\n' \
    "  Lock" \
    "  Logout" \
    "  Suspend" \
    "  Reboot" \
    "  Poweroff" \
    | rofi -dmenu -i -p "Power" -theme-str 'window { width: 220px; }')

case "$chosen" in
    *Lock)     loginctl lock-session ;;
    *Logout)   hyprctl dispatch exit ;;
    *Suspend)  systemctl suspend ;;
    *Reboot)   systemctl reboot ;;
    *Poweroff) systemctl poweroff ;;
esac
