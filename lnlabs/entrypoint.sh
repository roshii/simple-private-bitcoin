#!/bin/ash
set -e

DATADIR="/home/${LNLABS_SERVICE}/.${LNLABS_SERVICE}"
NETWORK="mainnet"
CONFIGDIR="${DATADIR}/${NETWORK}"

# Copy default config if none is found
if ! [ -f "${CONFIGDIR}/${CONFIG_FILE}" ]; then
  mkdir -p "$CONFIGDIR"
  cp "/etc/${CONFIG_FILE}" "$CONFIGDIR"
  chown -R "$LNLABS_SERVICE" "$DATADIR"
fi

exec su-exec "$LNLABS_SERVICE" "$@"
