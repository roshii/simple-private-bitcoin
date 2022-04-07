#!/bin/ash
set -e

datadir="/root/.joinmarket"
file_name="joinmarket.cfg"
target="${datadir}/${file_name}"

! [ -f "$target" ] && mv "/etc/${file_name}" "$target"

python "$@"
