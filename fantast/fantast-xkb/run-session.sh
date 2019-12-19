#!/bin/sh
set -ex

xkb_dir=$(dirname "$0")
layout="fantastRu"
mod=""
variant="basic"
warning_level=0

OPTIND=1

while getopts "i:l:m:v:w:" opt; do
  case "$opt" in
    i) xkb_dir="$OPTARG";;
    l) layout="$OPTARG";;
    m) mod="$OPTARG";;
    v) variant="$OPTARG";;
    w) warning_level="$OPTARG";;
    *) exit 1;;
  esac
done

if [ -z "$layout" ]; then
  echo "Empty layout"
  exit 2
fi

keycodes="evdev"
types="complete+fantastEn+fantastRu"

if ! [ -z "$mod" ]; then
  keycodes="$keycodes+$layout($mod)"
fi

if [ -f "$xkb_dir/types/$layout" ]; then
  types="$types+$layout"
fi

setxkbmap \
    -I "$xkb_dir" \
    -layout "$layout" \
    -variant "$variant" \
    -keycodes "$keycodes" \
    -types "$types" \
    -model pc105 \
    -option "srvrkeys:none,caps:ctrl_modifier,ctrl:menu_rctrl" \
    -print \
| xkbcomp \
    -w "$warning_level" \
    -I"$xkb_dir" \
    -o /tmp/temp.xkb \
    - -xkb
xkbcomp /tmp/temp.xkb -w "$warning_level" -o "$DISPLAY"
rm /tmp/temp.xkb

"$xkb_dir/scripts/install-xcompose.sh" "$layout"
