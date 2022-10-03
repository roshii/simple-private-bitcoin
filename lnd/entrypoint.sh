#!/bin/ash
set -e

configfile="lnd.conf"
datadir="/home/satoshi/.lnd"

# Copy default config if none is found
if ! [ -f "${datadir}/${configfile}" ]; then
  mkdir -p "$datadir"
  cp "/etc/${configfile}" "$datadir"
  chown -R satoshi /home/satoshi
fi

exec su-exec satoshi "$@"
