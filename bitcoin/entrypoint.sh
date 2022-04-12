#!/bin/ash
set -e

user="bitcoin"

# Copy default config if none is set
datadir="/srv/data"
file_name="bitcoin.conf"

if ! [ -f "${datadir}/${file_name}" ]; then
  cp "/etc/${file_name}" "$datadir"
fi

chown -R "$user" /var/lib/bitcoin
chown -R "$user" /srv

# Create joinmarket wallet is None is present
wallet="joinmarket"
walletdir="/srv/wallet"

! [ -d "${walletdir}/${wallet}" ] \
&& su-exec "$user" bitcoin-wallet -datadir="$walletdir" -wallet="$wallet" create

cmd="$1"
shift
su-exec "$user" "$cmd" -datadir="$datadir" "$@"
