#!/bin/bash

set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "This script should be run as root"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XKB_SRC="$SCRIPT_DIR/fantast-xkb"
XKB_DEST="/usr/share/X11/xkb"


. "$XKB_SRC/scripts/functions.sh"

function installLayout() {
  layout="$1"
  description="$2"
  variant="$3"
  variant_description="$4"
  flag="$5"

  copy_file "$XKB_SRC/symbols/$layout" "$XKB_DEST/symbols/$layout"
  copy_file "$XKB_SRC/types/$layout" "$XKB_DEST/types/$layout"
  copy_file "$XKB_SRC/keycodes/$layout" "$XKB_DEST/keycodes/$layout"

  if [ -f "$XKB_SRC/types/$layout" ]; then
    add_type "$XKB_DEST/rules/base" "$layout"
    add_type "$XKB_DEST/rules/evdev" "$layout"
  else
    remove_type "$XKB_DEST/rules/base" "$layout"
    remove_type "$XKB_DEST/rules/evdev" "$layout"
  fi

  add_description "$XKB_DEST/rules/base.lst" "$layout" "$description"
  add_description "$XKB_DEST/rules/evdev.lst" "$layout" "$description"

  "$XKB_SRC/scripts/remove-layout-from-xml.py" "$XKB_DEST/rules/base.xml" "$layout"
  "$XKB_SRC/scripts/add-layout-to-xml.py" "$XKB_DEST/rules/base.xml" "$layout" "$description" "$variant" "$variant_description"

  "$XKB_SRC/scripts/remove-layout-from-xml.py" "$XKB_DEST/rules/evdev.xml" "$layout"
  "$XKB_SRC/scripts/add-layout-to-xml.py" "$XKB_DEST/rules/evdev.xml" "$layout" "$description" "$variant" "$variant_description"

  #  add_models "$XKB_DEST/rules/base" "$mods" "$layout"
  #  add_models "$XKB_DEST/rules/evdev" "$mods" "$layout"
  #  "$XKB_SRC/scripts/remove-models-from-xml.py" "$XKB_DEST/rules/base.xml" "$mods"
  #  "$XKB_SRC/scripts/add-models-to-xml.py" "$XKB_DEST/rules/base.xml" "$mods" "$description_mods"
  #  "$XKB_SRC/scripts/remove-models-from-xml.py" "$XKB_DEST/rules/evdev.xml" "$mods"
  #  "$XKB_SRC/scripts/add-models-to-xml.py" "$XKB_DEST/rules/evdev.xml" "$mods" "$description_mods"


  cp -f "/usr/share/iso-flag-png/$flag.png" "/usr/share/iso-flag-png/$layout.png"
}

installLayout "fantastEn" "Fantast-En" "basic" "basic" "us"
installLayout "fantastRu" "Fantast-Ru" "basic" "basic" "ru"
installLayout "fantastNarrowEn" "Fantast-Narrow-En" "basic" "basic" "us"
installLayout "fantastNarrowRu" "Fantast-Narrow-Ru" "basic" "basic" "ru"
