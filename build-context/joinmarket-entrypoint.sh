#!/bin/ash
set -eux

SSLDIR="/home/satoshi/.joinmarket/ssl"

if [ ! -e "${SSLDIR}/key.pem" ] ; then
  mkdir -p "$SSLDIR"
  openssl genpkey -algorithm ed25519 -out "${SSLDIR}/key.pem"
  openssl pkey -in "${SSLDIR}/key.pem" -out "${SSLDIR}/pub.pem"
  openssl req -new -x509 -key "${SSLDIR}/key.pem" -out "${SSLDIR}/cert.pem" -days 360 -nodes \
    -subj "/CN=joinmarket"
fi

"$@"