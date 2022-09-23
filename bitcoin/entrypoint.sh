#!/bin/ash
set -e

# Defaults
user="bitcoin"
configfile="bitcoin.conf"
datadir="/home/${user}/.bitcoin"

# Copy default config if none is set
configfilepath="${datadir}/${configfile}"
if ! [ -f "$configfilepath" ]; then
  cp "/etc/${configfile}" "$datadir"
fi

# Create joinmarket wallet if not existing
wallet="joinmarket"
! [ -d "${datadir}/${wallet}" ] \
&& su-exec "$user" bitcoin-wallet -wallet="$wallet" -legacy create

# Set files and folders permissions
chown -R "$user" "$datadir"
chown -R "$user" /var/lib/bitcoin
sleep 10 && chmod 640 /var/lib/bitcoin/.cookie &

exec su-exec "$user" "$@"
