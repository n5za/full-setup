#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/wallpaper"
SWITCHWALL="$HOME/.config/quickshell/ii/scripts/colors/switchwall.sh"

if [ -z "${ILLOGICAL_IMPULSE_VIRTUAL_ENV:-}" ]; then
  export ILLOGICAL_IMPULSE_VIRTUAL_ENV="$HOME/.local/state/quickshell/.venv"
fi

mapfile -d '' -t CANDIDATES < <(
  find "$WALLPAPER_DIR" -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.avif' -o -iname '*.bmp' \) \
    -print0 2>/dev/null
)

if [ "${#CANDIDATES[@]}" -eq 0 ]; then
  exit 1
fi

IMG="${CANDIDATES[$((RANDOM % ${#CANDIDATES[@]}))]}"

MODE="dark"
current_scheme="$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null | tr -d "'")"
if [ "$current_scheme" = "prefer-light" ]; then
  MODE="light"
fi

exec "$SWITCHWALL" --mode "$MODE" --image "$IMG"