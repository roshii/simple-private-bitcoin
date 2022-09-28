#!/bin/ash
set -e

SERVICE="loop"
CONFIG_FILE="${SERVICE}d.conf"
DATADIR="/home/${SERVICE}/.${SERVICE}"
NETWORK="mainnet"
CONFIGDIR="${DATADIR}/${NETWORK}"

# Copy default config if none is found
if ! [ -f "${CONFIGDIR}/${CONFIG_FILE}" ]; then
  mkdir -p "$CONFIGDIR"
  cp "/etc/${CONFIG_FILE}" "$CONFIGDIR"
  chown -R "$SERVICE" "$DATADIR"
fi

exec su-exec "$SERVICE" "$@"
