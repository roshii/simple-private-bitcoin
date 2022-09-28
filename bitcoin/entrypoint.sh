#!/bin/ash
set -e

# Defaults
user="bitcoin"
configfile="bitcoin.conf"
datadir="/home/${user}/.bitcoin"

# Copy default config if none is found
if ! [ -f "${datadir}/${configfile}" ]; then
  mkdir -p "$datadir"
  cp "/etc/${configfile}" "$datadir"
  chown -R "$user" "/home/${user}"
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
