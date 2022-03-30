#!/bin/ash
set -e
script="$1"
args="${@/$1}"
exec python "$script" --datadir=/srv $args
