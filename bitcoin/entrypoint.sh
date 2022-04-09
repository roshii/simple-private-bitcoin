#!/bin/ash
set -e

user="bitcoin"

# Copy default config if none is set
datadir="/srv/data"
confdir="/home/${user}/.bitcoin"
file_name="bitcoin.conf"
target="${datadir}/${file_name}"


if ! [ -f "$target" ]; then
  cp "/etc/${file_name}" "$datadir"
  mkdir -p "${confdir}"
  ln -sf "$target" "${confdir}/${file_name}"
fi

chown -R "$user" /var/lib/bitcoin
chown -R "$user" /srv

# Create joinmarket wallet is None is present
walletdir="/srv/wallet"
wallet="joinmarket"

! [ -d "${walletdir}/${wallet}" ] \
&& su-exec "$user" bitcoin-wallet -datadir="$walletdir" -wallet="$wallet" create

su-exec "$user" "$@"
