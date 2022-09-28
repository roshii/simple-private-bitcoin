#!/bin/ash
set -e

user="lnd"
configfile="lnd.conf"
datadir="/home/${user}/.lnd"

# Copy default config if none is found
if ! [ -f "${datadir}/${configfile}" ]; then
  mkdir -p "$datadir"
  cp "/etc/${configfile}" "$datadir"
  chown -R "$user" "/home/${user}"
fi

exec su-exec "$user" "$@"
