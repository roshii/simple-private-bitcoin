#!/bin/ash
set -e

# Defaults
user="lnd"
configfile="lnd.conf"
datadir="/home/${user}/.lnd"

# Copy default config if none is set
configfilepath="${datadir}/${configfile}"
if ! [ -f "$configfilepath" ]; then
  cp "/etc/${configfile}" "$datadir"
  chown "$user" "$configfilepath"
fi

[[ -z $(pgrep lndconnect) ]] && su-exec "$user" lndconnect -c -o &

exec su-exec "$user" "$@"
