#!/bin/ash
set -e
datadir=/root/.joinmarket
config_file="${datadir}/joinmarket.cfg"
! [[ -f "$config_file" ]] && mv /tmp/joinmarket.cfg "$config_file"
python $@
