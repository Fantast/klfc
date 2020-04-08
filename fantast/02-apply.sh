#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XKB_SRC="$SCRIPT_DIR/fantast-xkb"

keycodes="evdev"
types="complete+fantastEn+fantastRu"
layout="fantastEn,fantastRu"
variant="basic,basic"
option="srvrkeys:none"

warning_level=0

setxkbmap -model pc105 -layout "us,ru" -option && \
setxkbmap \
    -I "$XKB_SRC" \
    -model pc105 \
    -keycodes "$keycodes" \
    -types "$types" \
    -layout "$layout" \
    -variant "$variant" \
    -option "$option" \
    -print \
| xkbcomp \
    -w "$warning_level" \
    -I"$XKB_SRC" \
    -o /tmp/temp.xkb \
    - -xkb
xkbcomp /tmp/temp.xkb -w "$warning_level" -o "$DISPLAY"
rm /tmp/temp.xkb
