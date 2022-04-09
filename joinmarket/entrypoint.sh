#!/bin/ash
set -e

user="jm"
datadir="/srv"
scriptdir="/opt/jm"
chown -R "$user" "$datadir"

# Add datadir flag for Joinmarket scripts
cmd="$1"
found=$(find "$scriptdir" -name "$cmd" -type f -print)

if [ "$cmd" == "joinmarketd.py" ] ; then
  su-exec "$user" python "$@"
elif [ -n "$found" ] ; then
  shift
  su-exec "$user" python "$cmd" "--datadir=${datadir}" "$@"
else
  su-exec "$user" "$@"
fi
