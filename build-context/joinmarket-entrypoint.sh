#!/bin/ash
set -e

DATADIR="/srv"
SCRIPTDIR="/opt/jm"

CMD="$1"
SCRIPTS=$(find "$SCRIPTDIR" -name "$CMD" -type f -print)

if [ "$CMD" == "joinmarketd.py" ] ; then
  exec python "$@"
elif [ -n "$SCRIPTS" ] ; then
  shift
  exec python "$CMD" "--datadir=${DATADIR}" "$@"
else
  exec "$@"
fi
