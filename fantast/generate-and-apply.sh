#!/bin/bash

set -e

./generate.sh

system-setup-keyboard-normal && cd ~/work/klfc/fantast/fantast-xkb && ./run-session.sh -l "fantastEn,fantastRu" -v "basic,basic"
