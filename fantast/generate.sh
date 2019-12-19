#!/bin/bash

set -e

# klfc fantast-wide-en.json fantast-wide-altgr.json fantast-wide-extend.json --xkb fantast-xkb

klfc fantast-wide-en.json fantast-wide-altgr.json fantast-wide-extend.json --xkb-redirect-all --xkb-redirect-clears-extend --xkb fantast-xkb
klfc fantast-wide-ru.json fantast-wide-altgr.json fantast-wide-extend.json --xkb-redirect-all --xkb-redirect-clears-extend --xkb fantast-xkb

# sed -i \
#    -e 's/=<AD09>/=<UP>/g' \
#    -e 's/=<AC08>/=<LEFT>/g' \
#    -e 's/=<AC09>/=<DOWN>/g' \
#    -e 's/=<AC10>/=<RGHT>/g' \
#    ./fantast-xkb/symbols/fantastEn
