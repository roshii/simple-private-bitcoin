#!/bin/ash
set -e

datadir="/srv"
scriptdir="/opt/jm"

# # Copy default config if none is set
# file_name="joinmarket.cfg"
# target="${datadir}/${file_name}"

# if ! [ -f "$target" ]; then
#   cp "/etc/${file_name}" "$datadir"
# fi

# chown -R satoshi "$datadir"

# Add datadir flag for Joinmarket scripts
cmd="$1"
found=$(find "$scriptdir" -name "$cmd" -type f -print)

if [ "$cmd" == "joinmarketd.py" ] ; then
  exec python "$@"
elif [ -n "$found" ] ; then
  shift
  exec python "$cmd" "--datadir=${datadir}" "$@"
else
  exec "$@"
fi
